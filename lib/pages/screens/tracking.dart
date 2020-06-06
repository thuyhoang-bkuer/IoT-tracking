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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<DeviceBloc, DeviceState>(
        listener: (context, state) {},
        child: BlocBuilder<DeviceBloc, DeviceState>(
          builder: (context, state) {
            if (state is DeviceInitial)
              return _initialView(context, state);
            else if (state is DeviceLoading)
              return _loadingView(context, state);
            else if (state is DeviceLoaded)
              return _mapView(context, state);
            else if (state is DeviceError)
              return _initialView(context, state);
            else
              throw Error;
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleHistoryBoard,
        elevation: 1,
        focusElevation: 0,
        highlightElevation: 0,
        backgroundColor: Styles.yellowy.withOpacity(0.8),
        child: Icon(
          Icons.history,
          size: 24,
          color: Styles.nearlyWhite,
        ),
        splashColor: Styles.yellowy,
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

  void toggleHistoryBoard() {}
}
