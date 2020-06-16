import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'enums.dart';

class Device extends Equatable {
  String id;
  Power status;
  String name;
  Position position;

  Device({
    this.id,
    this.status = Power.Off,
    this.name = 'Unknown',
    this.position,
  });

  static List<Device> fromMaps(dynamic message) {
    if (message == null) {
      throw ArgumentError('The parameter \'message\' should not be null.');
    }

    final List<Device> list = message.map<Device>(fromMap).toList();
    return list;
  }

  static Device fromMap(dynamic message) {
    Map<String, dynamic> map = message;

    return Device(
      id: map['id'],
      status: map.containsKey('status') ? Power.values[map['status']] : Power.On,
      name: map['name'],
      position: map.containsKey('position') ? Position.fromMap(map['position']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status.index,
      'name': name,
      'position': position.toJson()
    };
  }

  @override
  List<Object> get props => [id, status, name, position];
}
