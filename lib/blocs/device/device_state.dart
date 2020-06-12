part of 'device_bloc.dart';

abstract class DeviceState extends Equatable {
  final List<Device> devices;

  const DeviceState(this.devices);
}

class DeviceInitial extends DeviceState {
  const DeviceInitial(List<Device> devices) : super(devices);
  @override
  List<Object> get props => [super.devices];
}


class DeviceLoading extends DeviceState {
  const DeviceLoading(List<Device> devices) : super(devices);
  @override
  List<Object> get props => [super.devices];
}

class DeviceLoaded extends DeviceState {
  const DeviceLoaded(List<Device> devices) : super(devices);
  
  @override
  List<Object> get props => [super.devices];
}

class DeviceError extends DeviceState {
  final String error;
  const DeviceError({this.error}) : super(const []);
  @override
  List<Object> get props => [super.devices, error];
}
