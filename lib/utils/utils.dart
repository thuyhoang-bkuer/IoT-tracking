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
    double minLat = 180, minLong = 180, maxLat = -180, maxLong = -180;

    points.forEach((point) {
      if (maxLat < point.latitude) {
        maxLat = point.latitude;
      }

      if (minLat > point.latitude) {
        minLat = point.latitude;
      }

      if (maxLong < point.longitude) {
        maxLong = point.longitude;
      }

      if (minLong > point.longitude) {
        minLong = point.longitude;
      }
    });

    if (maxLong - minLong < 0.01) {
      maxLong += 0.005;
      minLong -= 0.005;
    }
    if (maxLat - minLat < 0.01) {
      maxLat += 0.005;
      minLat -= 0.005;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLong),
      northeast: LatLng(maxLat, maxLong),
    );
  }

  static String retriveDate(DateTime timestamp, double history) {
    return DateFormat('MMM dd, ' 'yy\n   hh:mm aaa').format(
      timestamp.add(
        // Hanoi 7+
        Duration(hours: 7,minutes: history.toInt()),
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

      num distance =
          cacheX - cacheY * (differentX - cacheX) / (differentY - cacheY);

      if (distance == 0) return true; // point on edge
      if (distance > 0) hitTimes++;
    }

    return (hitTimes & 1) == 1;
  }
}
