part of 'mqtt_bloc.dart';

abstract class MqttEvent extends Equatable {
  const MqttEvent();
}

class MqttInitialize extends MqttEvent {
  final MqttClientWrapper mqttClientWrapper;
  MqttInitialize(this.mqttClientWrapper);
  @override
  List<Object> get props => [mqttClientWrapper];
}

class MqttConnect extends MqttEvent {
  final String topic;
  final Map<String, dynamic> payload;
  MqttConnect({this.topic, this.payload});
  @override
  List<Object> get props => [topic, payload];
}

class MqttDisconnect extends MqttEvent {
  MqttDisconnect();
  @override
  List<Object> get props => [];
}
