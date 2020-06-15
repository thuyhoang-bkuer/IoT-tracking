part of 'mqtt_bloc.dart';

abstract class MqttState extends Equatable {
  const MqttState();
}

class MqttInitial extends MqttState {
  @override
  List<Object> get props => [];
}

class MqttLoading extends MqttState {
   @override
  List<Object> get props => [];
}

class MqttConnected extends MqttState {
  @override
  List<Object> get props => [];
}

class MqttError extends MqttState {
  @override
  List<Object> get props => [];
}
