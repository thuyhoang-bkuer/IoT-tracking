import 'package:mqtt_client/mqtt_client.dart';

class MqttConfig {
  final String serverUri;
  final String username;
  final String password;
  final String topicName;
  final String clientIdentifier;
  final MqttQos usedQoS;

  final int port;
  final int keepAlivePeriod;

  MqttConfig({
    this.clientIdentifier,
    this.serverUri,
    this.username,
    this.password,
    this.topicName,
    this.usedQoS,
    this.port,
    this.keepAlivePeriod,
  });
}
