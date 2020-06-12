import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tracking_app/blocs/_.dart';
import 'package:tracking_app/models/_.dart';
import 'package:tracking_app/styles/index.dart';

class HistoryUtils {
  static Set<Marker> retriveAllPoints(
    BuildContext context,
    List<Device> devices,
    Function(Device) callback,
  ) {
    return devices.where((device) => device.status == Power.On).map((device) {
      final LatLng latLng =
          LatLng(device.position.latitude, device.position.longitude);
      return Marker(
        markerId: MarkerId(device.id.toString()),
        position: latLng,
        draggable: false,
        onTap: () => callback(device),
      );
    }).toSet();
  }

  static LatLngBounds retriveBoundOf(List<LatLng> points) {
    LatLng northeast = LatLng(-180, -180), southwest = LatLng(180, 180);

    points.forEach((point) {
      if (northeast.latitude < point.latitude) {
        northeast = point;
      }
      if (southwest.latitude > point.latitude) {
        southwest = point;
      }
    });

    if (northeast.longitude - southwest.longitude < 0.01) {
      southwest = LatLng(southwest.latitude, southwest.longitude - 0.005);
      northeast = LatLng(northeast.latitude, northeast.longitude + 0.005);
    }

    return LatLngBounds(southwest: southwest, northeast: northeast);
  }

  static String retriveDate(DateTime timestamp, double history) {
    return DateFormat('MMM dd, ' 'yy\n   hh:mm aaa').format(
      timestamp.add(
        Duration(minutes: history.toInt()),
      ),
    );
  }
}
