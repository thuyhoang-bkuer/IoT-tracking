part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();
}

class FetchDevices extends DeviceEvent {
  final String topic;
  final Map<String, dynamic> payload;

  const FetchDevices({this.topic, this.payload});
  @override
  List<Object> get props => [topic, payload];
}

class SubcribePosition extends DeviceEvent {
  final String topic;
  final Map<String, dynamic> payload;

  SubcribePosition({this.topic, this.payload});
  @override
  List<Object> get props => [topic, payload];
}

class PutDevice extends DeviceEvent {
  final String topic;
  final Map<String, dynamic> payload;

  const PutDevice({this.topic, this.payload});
  
  @override
  List<Object> get props => [topic, payload];
}


class LocateDevice extends DeviceEvent {
  final String topic;
  final Map<String, dynamic> payload;
  const LocateDevice({this.topic, this.payload});

  @override
  List<Object> get props => [topic, payload];
}