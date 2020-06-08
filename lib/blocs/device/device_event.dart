part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();
}

class FetchDevices extends DeviceEvent {
  final String topic;
  final String payload;

  const FetchDevices({this.topic, this.payload});
  @override
  List<Object> get props => [topic, payload];
}

class GetCoordinate extends DeviceEvent {
  final String topic;
  final String payload;

  GetCoordinate(this.topic, this.payload);
  @override
  List<Object> get props => [topic, payload];
  
}

class PutDevice extends DeviceEvent {
  final String topic;
  final String payload;

  const PutDevice({this.topic, this.payload});
  
  @override
  List<Object> get props => [topic, payload];
}


class LocateDevice extends DeviceEvent {
  final String topic;
  final String payload;
  const LocateDevice({this.topic, this.payload});

  @override
  List<Object> get props => [topic, payload];
}