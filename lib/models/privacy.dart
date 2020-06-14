import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Privacy extends Equatable {
  final String id;
  final String deviceId;
  final DateTime timeEnd;
  final DateTime timeStart;
  final String placement;
  final List<LatLng> place;

  Privacy(this.id, {
    this.deviceId,
    this.timeEnd,
    this.timeStart,
    this.placement,
    this.place,
  });

  static List<Privacy> fromMaps(dynamic message) {
    if (message == null) {
      throw ArgumentError('The parameter \'message\' should not be null.');
    }

    final List<Privacy> list = message.map<Privacy>(fromMap).toList();
    return list;
  }

  static Privacy fromMap(dynamic message) {
    final Map<String, dynamic> map = message;
    return Privacy(
      map['_id'],
      deviceId: map['deviceId'],
      placement: map['placement'],
      timeEnd: DateTime.fromMillisecondsSinceEpoch(
        map['timeEnd'].toInt(),
        isUtc: false,
      ),
      timeStart: DateTime.fromMillisecondsSinceEpoch(
        map['timeStart'].toInt(),
        isUtc: false,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'timeStart': timeStart.millisecondsSinceEpoch,
      'timeEnd': timeEnd.millisecondsSinceEpoch,
      'placement': placement
    };
  }

  @override
  List<Object> get props => [deviceId, timeEnd, timeStart, placement, place];
}
