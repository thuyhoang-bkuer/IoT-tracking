import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tracking_app/blocs/_.dart';
import 'package:tracking_app/styles/index.dart';

class TitleBar extends StatelessWidget {
  final Color primaryColor;

  const TitleBar({Key key, this.primaryColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final devices = BlocProvider.of<DeviceBloc>(context).state.devices;
    final random = Random();

    return Material(
      elevation: 7.0,
      child: Padding(
        padding: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  "Tracking Lover",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 27,
                      fontWeight: FontWeight.w500),
                )),
            FloatingActionButton(
              mini: true,
              backgroundColor: Colors.transparent,
              splashColor: Styles.blueky.withOpacity(0.15),
              highlightElevation: 0,
              elevation: 0,
              onPressed: () =>
                  BlocProvider.of<DeviceBloc>(context).add(FetchDevices()),
              child: Icon(
                Icons.wifi,
                size: 24,
              ),
              foregroundColor: Styles.blueky,
            ),
            FloatingActionButton(
              mini: true,
              backgroundColor: Colors.transparent,
              splashColor: Styles.blueky.withOpacity(0.15),
              highlightElevation: 0,
              elevation: 0,
              onPressed: () {
                final id = random.nextInt(devices.length);
                final device = devices[id];
                final payload = json.encode({
                  "id": id,
                  "latitude": (random.nextDouble() - 0.5) * 0.003 +
                      device.position.latitude,
                  "longitude": (random.nextDouble() - 0.5) * 0.003 +
                      device.position.longitude,
                });
                BlocProvider.of<DeviceBloc>(context).add(
                  LocateDevice(payload: payload),
                );
              },
              child: Icon(
                Icons.gps_fixed,
                size: 24,
              ),
              foregroundColor: Styles.blueky,
            ),
          ],
        ),
      ),
    );
  }
}
