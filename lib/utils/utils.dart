import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tracking_app/models/_.dart';

class Utils {
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
      southwest = LatLng(southwest.latitude, southwest.longitude - 0.01);
      northeast = LatLng(northeast.latitude, northeast.longitude + 0.01);
    }
    if (northeast.latitude - southwest.latitude < 0.01) {
      southwest = LatLng(southwest.latitude - 0.005, southwest.longitude);
      northeast = LatLng(northeast.latitude - 0.005, northeast.longitude);
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

  static bool isInsideARegion(List<LatLng> polygon, LatLng point) {
    num cacheX = 0, cacheY = 0;
    num differentX = polygon.last.latitude - point.latitude;
    num differentY = polygon.last.longitude - point.longitude;
    int hitTimes = 0;

    for (int i = 0; i < polygon.length; i++) {
      cacheX = differentX;
      cacheY = differentY;
      differentX = polygon[i].latitude - point.latitude;
      differentY = polygon[i].longitude - point.longitude;

      if (cacheY < 0 && differentY < 0) continue; // both "up" or both "down"
      if (cacheY > 0 && differentY > 0) continue; // both "up" or both "down"
      if (cacheX < 0 && differentX < 0) continue; // both points on left


      num distance = cacheX - cacheY * (differentX - cacheX) / (differentY - cacheY);

      if (distance == 0) return true; // point on edge
      if (distance > 0) hitTimes++;
    }

    return (hitTimes & 1) == 1;
  }
}
