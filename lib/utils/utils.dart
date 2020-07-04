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

  static double maxof(double a, double b){
    if(a > b){
      return a;
    }else{
      return b;
    }
  }

  static double minof(double a, double b){
    if(a < b){
      return a;
    }else{
      return b;
    }
  }

  static bool onSegment(var p, var q, var r){
    if(q[0] <= maxof(p[0],r[0]) && q[0] >= minof(p[0],q[0]) && q[1] <= maxof(p[1],r[1]) && q[1] >= minof(p[1],q[1]))
      return true;
    else
      return false;
  }

  static int orientation(var p, var q, var r){
    var lin = (q[1] - p[1]) * (r[0] - q[0]) - (q[0] - p[0]) * (r[1] - q[1]);  
      if(lin == 0) return 0;
      return (lin > 0)? 1:2;
  }

  static bool doIntersect(var p1, var q1, var p2, var q2){
    var o1 = orientation(p1,q1,p2);
    var o2 = orientation(p1,q1,q2);
    var o3 = orientation(p2,q2,p1);
    var o4 = orientation(p2,q2,q1);

    if(o1 != o2 && o3 != o4)
      return true;

    if(o1 == 0 && onSegment(p1,p2,q1)) return true;
    if(o2 == 0 && onSegment(p1,q2,q1)) return true;
    if(o3 == 0 && onSegment(p2,p1,q2)) return true;
    if(o4 == 0 && onSegment(p2,p1,q2)) return true;
    return false;
  }

  static bool isInside(List<dynamic> polygon, List<double> p){
    var n = polygon.length;
    if (n < 3) return false;
    var extreme = [12, p[1]];
    var count  = 0, i = 0;
    do{
      var next = (i + 1) % n;
      if(doIntersect(polygon[i], polygon[next], p, extreme)){
        if(orientation(polygon[i], p, polygon[next]) == 0)
          return onSegment(polygon[i], p, polygon[next]);
        count++;
      }
      i = next;
    }while (i != 0);
    var res = count & 1;
    if(res > 0) return true;
    else return false;
  }
}
