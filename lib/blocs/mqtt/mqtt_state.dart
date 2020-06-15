part of 'mqtt_bloc.dart';

abstract class MqttState extends Equatable {
  const MqttState();
}

class MqttUnitial extends MqttState {
  @override
  List<Object> get props => [];
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
  final String error;
  MqttError(this.error);
  @override
  List<Object> get props => [error];
}
