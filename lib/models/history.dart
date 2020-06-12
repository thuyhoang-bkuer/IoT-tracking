import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

class History extends Equatable {
  String deviceId;
  List<Position> positions;

  History({this.deviceId, this.positions});

  factory History.fromJson(Map<String, dynamic> map) {
    return History(
      deviceId: map['deviceId'],
      positions: Position.fromMaps(map['positions']),
    );
  }

  @override
  List<Object> get props => [deviceId, positions];
}
