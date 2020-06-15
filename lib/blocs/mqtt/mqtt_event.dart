part of 'mqtt_bloc.dart';

abstract class MqttEvent extends Equatable {
  final String topic;
  final Map<String, dynamic> payload;
  const MqttEvent(this.topic, this.payload);
}

class MqttConnect extends MqttEvent {
  MqttConnect({String topic, Map<String, dynamic> payload}) : super(topic, payload);
  @override
  List<Object> get props => [];
}

class MqttDisconnect extends MqttEvent {
  MqttDisconnect({String topic, Map<String, dynamic> payload}) : super(topic, payload);
  @override
  List<Object> get props => [];
}
