import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracking_app/blocs/_.dart';
import 'package:tracking_app/models/device.dart';
import 'package:tracking_app/models/enums.dart';
import 'package:tracking_app/styles/index.dart';

class TrackingScreen extends StatefulWidget {
  final constant = {'latitude': 10.81, 'longitude': 106.65, 'zoom': 12.3};
  final primaryColor = Styles.blueky;

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  GoogleMapController _googleController;
  bool hasModal;
  Timer interval;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    hasModal = false;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviceBloc, DeviceState>(
      listener: (context, state) {},
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
            body: body,
            floatingActionButton: isFabEnable
                ? hasModal
                    ? Builder(
                        builder: (context) => FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              hasModal = false;
                            });
                            Navigator.pop(context);
                          },
                          elevation: 1,
                          focusElevation: 0,
                          highlightElevation: 0,
                          backgroundColor: Styles.yellowy,
                          child: Icon(
                            Icons.close,
                            size: 24,
                            color: Styles.nearlyWhite,
                          ),
                          splashColor: Styles.yellowy,
                        ),
                      )
                    : Builder(
                        builder: (context) => FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              hasModal = true;
                            });
                            toggleHistoryBoard(context, state);
                          },
                          elevation: 1,
                          focusElevation: 0,
                          highlightElevation: 0,
                          backgroundColor: Styles.yellowy,
                          child: Icon(
                            Icons.history,
                            size: 24,
                            color: Styles.nearlyWhite,
                          ),
                          splashColor: Styles.yellowy,
                        ),
                      )
                : null,
          );
        },
      ),
    );
  }

  Widget _mapView(BuildContext context, DeviceState state) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
          target:
              LatLng(widget.constant['latitude'], widget.constant['longitude']),
          zoom: widget.constant['zoom']),
      markers: state.devices == null ? Set() : _retriveAllPoints(state.devices),
      onMapCreated: (GoogleMapController controller) {
        setState(() {
          this._googleController = controller;
        });
      },
      zoomControlsEnabled: false,
    );
  }

  Set<Marker> _retriveAllPoints(List<Device> devices) {
    return devices.where((device) => device.status == Power.On).map((device) {
      final LatLng latLng =
          LatLng(device.position.latitude, device.position.longitude);
      return Marker(
        markerId: MarkerId(device.id.toString()),
        position: latLng,
        draggable: false,
        infoWindow: InfoWindow(title: "${device.id}"),
      );
    }).toSet();
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
            color: Styles.lightBlack,
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

  void toggleHistoryBoard(BuildContext context, DeviceState state) {
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
                        color: Styles.yellowy,
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
                          color: Styles.yellowy,
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
                          Navigator.pop(context);
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

  showHistoryOf(BuildContext context, int id) {
    Scaffold.of(context).showBottomSheet((context) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Styles.nearlyWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        height: MediaQuery.of(context).size.height / 6,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Déjà Vu - Device ${id.toString()}",
                style: TextStyle(
                  color: Styles.yellowy,
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: RangeSlider(
                inactiveColor: Styles.nearlyBlack,
                activeColor: Styles.yellowy,
                labels: RangeLabels("Start", "End"),
                divisions: 1,
                onChanged: (value) => {},
                min: -30,
                max: -1,
                values: RangeValues(-10, -1),
              ),
            ),
          ],
        ),
      );
    }, backgroundColor: Colors.transparent);
  }
}
