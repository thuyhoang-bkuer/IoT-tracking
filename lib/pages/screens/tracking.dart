import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tracking_app/blocs/_.dart';
import 'package:tracking_app/models/_.dart';
import 'package:tracking_app/utils/_.dart';
import 'package:tracking_app/styles/index.dart';
import 'package:tracking_app/widgets/title_bar.dart';

class TrackingScreen extends StatefulWidget {
  final constant = {'latitude': 10.81, 'longitude': 106.65, 'zoom': 11.0};
  final Color primaryColor;

  TrackingScreen({Key key, this.primaryColor}) : super(key: key);

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

enum ModalKind { None, Idle, HistoryBoard, HistoryDetail }

class _TrackingScreenState extends State<TrackingScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  GoogleMapController _googleController;
  ModalKind _modal;
  RangeValues _period;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _modal = ModalKind.None;
    _period = RangeValues(-1440.0, 0.0);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeviceBloc, DeviceState>(
          listener: (context, state) {
            log(state.toString());
            if (state is DeviceError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          },
        ),
        BlocListener<HistoryBloc, HistoryState>(
          listener: (context, state) {
            log(state.toString());
            Scaffold.of(context).showBodyScrim(false, 0.65);
            if (state is HistoryError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  duration: Duration(seconds: 1),
                ),
              );
            } else if (state is HistoryLoading) {
              Scaffold.of(context).showBodyScrim(true, 0.65);
            }
          },
        )
      ],
      child: BlocBuilder<DeviceBloc, DeviceState>(
        builder: (context, state) {
          Widget body;
          bool isFabEnable = false;
          if (state is DeviceInitial) {
            body = _initialView(context, state);
          } else if (state is DeviceLoading) {
            body = _loadingView(context, state);
          } else if (state is DeviceLoaded) {
            body = _mapView(context, state);
            isFabEnable = true;
          } else if (state is DeviceError) {
            body = _initialView(context, state);
          } else
            throw Error;

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: TitleBar(
                primaryColor: widget.primaryColor,
                pageIndex: 1,
                usedMqtt: true,
              ),
            ),
            body: body,
            floatingActionButton:
                isFabEnable ? _buildFab(context, state) : null,
          );
        },
      ),
    );
  }

  Widget _buildFab(BuildContext context, DeviceLoaded state) {
    if (_modal == ModalKind.HistoryBoard || _modal == ModalKind.HistoryDetail)
      return Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            if (_modal == ModalKind.HistoryDetail) {
              BlocProvider.of<HistoryBloc>(context).add(EraseHistory());
              final points = state.devices
                  .map(
                    (device) => LatLng(
                      device.position.latitude,
                      device.position.longitude,
                    ),
                  )
                  .toList();
              _googleController?.animateCamera(
                CameraUpdate.newLatLngBounds(Utils.retriveBoundOf(points), 140),
              );
            }
            Navigator.pop(context);
            setState(() => _modal = ModalKind.Idle);
          },
          elevation: 1,
          focusElevation: 0,
          highlightElevation: 0,
          backgroundColor: widget.primaryColor,
          child: Icon(
            Icons.close,
            size: 24,
            color: Styles.nearlyWhite,
          ),
          splashColor: widget.primaryColor,
        ),
      );
    else
      return Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            setState(() => _modal = ModalKind.HistoryBoard);
            toggleHistoryBoard(context, state);
          },
          elevation: 2,
          focusElevation: 0,
          highlightElevation: 0,
          backgroundColor: widget.primaryColor,
          child: Icon(
            Icons.history,
            size: 24,
            color: Styles.nearlyWhite,
          ),
          splashColor: widget.primaryColor,
        ),
      );
  }

  Widget _mapView(BuildContext context, DeviceState deviceState) {
    return BlocBuilder<HistoryBloc, HistoryState>(
      builder: (context, state) {
        Set<Marker> markers;
        Set<Polyline> polylines;

        if (state is HistoryInitial || state is HistoryError) {
          markers = Utils.retriveAllPoints(
            context,
            deviceState.devices,
            (device) {
              setState(() => _modal = ModalKind.HistoryDetail);
              BlocProvider.of<HistoryBloc>(context)
                  .add(FetchHistory(payload: {"deviceId": device.id}));
              showHistoryOf(context, device.id);
            },
          );
          polylines = Set();
          // _googleController?.animateCamera(
          //   CameraUpdate.newCameraPosition(
          //     CameraPosition(
          //       target: LatLng(
          //         widget.constant['latitude'],
          //         widget.constant['longitude'],
          //       ),
          //       zoom: widget.constant['zoom'],
          //     ),
          //   ),
          // );
        } else if (state is HistoryLoading) {
          markers = Utils.retriveAllPoints(
            context,
            deviceState.devices.where((d) => d.id == state.deviceId).toList(),
            (device) {
              setState(() => _modal = ModalKind.HistoryDetail);
              BlocProvider.of<HistoryBloc>(context)
                  .add(FetchHistory(payload: {"deviceId": device.id}));
              showHistoryOf(context, device.id);
            },
          );
          polylines = Set();
        } else if (state is HistoryLoaded) {
          final points = state.history.positions
              .map((p) => LatLng(p.latitude, p.longitude))
              .toList();
          markers = Set();
          polylines = Set()
            ..add(
              Polyline(
                polylineId: PolylineId(state.deviceId),
                points: points,
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
                color: widget.primaryColor,
              ),
            );
          _googleController?.animateCamera(
            CameraUpdate.newLatLngBounds(
              Utils.retriveBoundOf(points),
              140,
            ),
          );
        } else if (state is HistorySliced) {
          final points = state.sliced.positions
              .map((p) => LatLng(p.latitude, p.longitude))
              .toList();
          markers = Set();
          polylines = points.length == 0
              ? Set()
              : Set.from(
                  [
                    Polyline(
                      polylineId: PolylineId(state.deviceId.toString()),
                      points: points,
                      startCap: Cap.roundCap,
                      endCap: Cap.roundCap,
                      color: widget.primaryColor,
                    ),
                  ],
                );
        } else
          throw Error;

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.constant['latitude'],
              widget.constant['longitude'],
            ),
            zoom: widget.constant['zoom'],
          ),
          markers: markers,
          polylines: polylines,
          onMapCreated: (GoogleMapController controller) {
            setState(() {
              this._googleController = controller;
            });
          },
          zoomControlsEnabled: false,
          zoomGesturesEnabled: true,
          myLocationButtonEnabled: false,
        );
      },
    );
  }

  Widget _loadingView(BuildContext context, DeviceState state) {
    return Center(child: SpinKitPumpingHeart(color: widget.primaryColor));
  }

  Widget _initialView(BuildContext context, DeviceState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Icon(
            Icons.location_off,
            size: 128,
            color: Styles.deactivatedText,
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "No Devices",
              style: TextStyle(
                fontSize: 24,
                color: Styles.grey,
              ),
            ),
          ),
        )
      ],
    );
  }

  toggleHistoryBoard(BuildContext context, DeviceState state) {
    final availableDevices =
        state.devices.where((device) => device.status == Power.On).toList();

    Scaffold.of(context).showBottomSheet(
      (context) {
        return Material(
          color: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height / 3,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Styles.nearlyWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Details",
                      style: TextStyle(
                        color: widget.primaryColor,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: List.generate(
                      availableDevices.length,
                      (i) => ListTile(
                        leading: Icon(
                          Icons.location_on,
                          size: 32,
                          color: widget.primaryColor,
                        ),
                        title: Text(
                          availableDevices[i].name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(availableDevices[i].id.toString()),
                        onTap: () {
                          setState(() => _modal = ModalKind.HistoryDetail);
                          Navigator.pop(context);
                          BlocProvider.of<HistoryBloc>(context).add(
                            FetchHistory(
                              payload: {"deviceId": availableDevices[i].id},
                            ),
                          );
                          showHistoryOf(context, availableDevices[i].id);
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      backgroundColor: Colors.transparent,
    );
  }

  showHistoryOf(BuildContext context, String id) {
    Scaffold.of(context).showBottomSheet((context) {
      return BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          Widget child = Center();
          if (state is HistoryLoading) {
            child = Center(
              child: SpinKitDoubleBounce(
                color: widget.primaryColor,
                size: 32,
              ),
            );
          } else if (state is HistoryLoaded || state is HistorySliced) {
            final latest = state.positions.last;
            child = Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "Déjà Vu - Device ${id.toString()}",
                    style: TextStyle(
                      color: widget.primaryColor,
                      fontSize: 24,
                    ),
                  ),
                ),
                RaisedButton(
                  elevation: 2,
                  highlightElevation: 0,
                  color: widget.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: SizedBox(
                    height: 48,
                    width: 96,
                    child: Center(
                      child: Icon(
                        Icons.refresh,
                        size: 24,
                        color: Styles.nearlyWhite,
                      ),
                    ),
                  ),
                  onPressed: () {
                    BlocProvider.of<HistoryBloc>(context).add(
                      SliceHistory(
                        latest.timestamp
                            .add(Duration(minutes: _period.start.toInt())),
                        latest.timestamp
                            .add(Duration(minutes: _period.end.toInt())),
                      ),
                    );
                  },
                ),
                StatefulBuilder(
                  builder: (context, setState) {
                    return RangeSlider(
                      inactiveColor: Styles.nearlyBlack,
                      activeColor: widget.primaryColor,
                      labels: RangeLabels(
                        '${Utils.retriveDate(latest.timestamp, _period.start)}',
                        '${Utils.retriveDate(latest.timestamp, _period.end)}',
                      ),
                      divisions: 144,
                      onChanged: (value) {
                        setState(() => _period = value);
                      },
                      min: -1440.0,
                      max: 0,
                      values: _period,
                    );
                  },
                ),
              ],
            );
          } else if (state is HistoryError) {
            child = Center(
              child: Icon(
                Icons.error,
                size: 64,
                color: Styles.deactivatedText,
              ),
            );
          }

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Styles.nearlyWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            height: MediaQuery.of(context).size.height / 4,
            child: child,
          );
        },
      );
    }, backgroundColor: Colors.transparent);
  }
}
