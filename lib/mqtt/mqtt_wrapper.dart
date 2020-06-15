import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:tracking_app/models/_.dart';

class MqttClientWrapper {
  MqttConfig config;
  MqttClient client;
  MqttClientConnectionState connectionState = MqttClientConnectionState.Idle;
  MqttClientSubcriptionState subscriptionStatus =
      MqttClientSubcriptionState.Idle;

  final VoidCallback onConnectedCallback;
  final Function(dynamic) onDataReceivedCallback;

  MqttClientWrapper({this.onConnectedCallback, this.onDataReceivedCallback});

  void prepareMqttClient() async {
    _setupMqttClient();
    await _connectClient();
    _subscribeToTopic();
  }

  void publishMessage(String payload) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(payload);

    log('[MQTT Client] Publish message $payload to topic ${config.topicName}');
    client.publishMessage(config.topicName, config.usedQoS, builder.payload);
  }

  void _setupMqttClient() {
    final MqttConnectMessage connectMessage = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .keepAliveFor(20) // Must agree with the keep alive set above or not set
        .startClean() // Non persistent session for testing
        .authenticateAs(
          config.username,
          config.password,
        ) // additional code when connecting to a broker w/ creds
        .withWillQos(config.usedQoS);

    client = MqttClient.withPort(
        config.serverUri, config.clientIdentifier, config.port);
    client.logging(on: true);
    client.connectionMessage = connectMessage;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  Future<void> _connectClient() async {
    try {
      log('[MQTT Client] Mosquitto client connecting....');
      connectionState = MqttClientConnectionState.Connecting;
      await client.connect(config.username, config.password);
    } on Exception catch (e) {
      log('[MQTT Client] Exception - $e');
      connectionState = MqttClientConnectionState.ErrorWhenConnecting;
      client.disconnect();
    }

    if (client.connectionStatus.state == MqttConnectionState.connected) {
      connectionState = MqttClientConnectionState.Connected;
      log('[MQTT Client] Client connected');
    } else {
      log('[MQTT Client] Client ${client.connectionStatus}, disconnecting..');
      connectionState = MqttClientConnectionState.ErrorWhenConnecting;
      client.disconnect();
    }
  }

  void _onSubscribed(String topic) {
    log('[MQTT Client] Subscription confirmed for topic $topic');
    subscriptionStatus = MqttClientSubcriptionState.Idle;
  }

  void _onDisconnected() {
    log('[MQTT Client] OnDisconnected client callback - Client disconnection');
    connectionState = MqttClientConnectionState.Disconnected;
  }

  void _onConnected() {
    connectionState = MqttClientConnectionState.Connected;
    log('[MQTT Client] OnConnected client callback - Client connected!');
    onConnectedCallback();
  }

  void _subscribeToTopic() {
    print('[MQTT Client] Subscribing to the ${config.topicName} topic');
    client.subscribe(config.topicName, config.usedQoS);

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage receivedMsg = c[0].payload;
      final String data =
          MqttPublishPayload.bytesToStringAsString(receivedMsg.payload.message);
      log('[MQTT Client] Got a message $data');
      
      onDataReceivedCallback(data);
    });
  }
}
