import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'enums.dart';

class Device extends Equatable {
  int id;
  Power status;
  String name;
  List<Position> positions;

  Device({
    this.id, 
    this.status = Power.Off, 
    this.name = 'Unknown', 
    this.positions = const []
  });

  static Device convertFromJson(String jString) {
    return null;
  }

  static String convertToJson() {
    return '';
  }

  @override
  List<Object> get props => [id, status, name, positions];
}