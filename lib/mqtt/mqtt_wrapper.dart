import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:tracking_app/data/device_repository.dart';
import 'package:tracking_app/models/_.dart';

class MqttClientWrapper {
  MqttClient client;
  var connectionState = MqttClientConnectionState.Idle;
  var subscriptionStatus = MqttClientSubcriptionState.Idle;

  MqttConfig _config;
  final VoidCallback onConnectedCallback;
  final VoidCallback onDisconnectedCallback;
  final Function(String) onDataReceivedCallback;

  MqttClientWrapper({
    this.onConnectedCallback,
    this.onDisconnectedCallback,
    this.onDataReceivedCallback,
  });

  Future<MqttClientConnectionStatus> prepareMqttClient(MqttConfig config) async {
    _updateConfig(config);
    _setupMqttClient();
    return await _connectClient();
  }

  void publishMessage(String payload) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(payload);

    log('[MQTT Client] Publish message $payload to topic ${_config.topicName}');
    client.publishMessage(_config.topicName, _config.usedQoS, builder.payload);
  }

  void subscribeToTopic() {
    print('[MQTT Client] Subscribing to the ${_config.topicName} topic');
    client.subscribe(_config.topicName, _config.usedQoS);

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage receivedMsg = c[0].payload;
      final String data =
          MqttPublishPayload.bytesToStringAsString(receivedMsg.payload.message);
      log('[MQTT Client] Got a message $data');

      onDataReceivedCallback?.call(data);
    });
  }

  void _updateConfig(MqttConfig config) {
    _config = config;
  }

  void _setupMqttClient() {
    final MqttConnectMessage connectMessage = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .keepAliveFor(1000) // Must agree with the keep alive set above or not set
        .startClean() // Non persistent session for testing
        .authenticateAs(
          _config.username,
          _config.password,
        ) // additional code when connecting to a broker w/ creds
        .withWillQos(_config.usedQoS);

    client = MqttServerClient(_config.serverUri, _config.clientIdentifier);
    client.logging(on: true);
    client.connectionMessage = connectMessage;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  Future<MqttClientConnectionStatus> _connectClient() async {
    MqttClientConnectionStatus status;
    try {
      log('[MQTT Client] Mosquitto client connecting....');
      connectionState = MqttClientConnectionState.Connecting;
      status = await client.connect(_config.username, _config.password);
    } catch (e) {
      log('[MQTT Client] Exception - $e');
      connectionState = MqttClientConnectionState.ErrorWhenConnecting;
      client.disconnect();
      throw NetworkError();
    }
    

    if (client.connectionStatus.state == MqttConnectionState.connected) {
      connectionState = MqttClientConnectionState.Connected;
      log('[MQTT Client] Client connected');
    } else {
      log('[MQTT Client] Client ${client.connectionStatus}, disconnecting..');
      connectionState = MqttClientConnectionState.ErrorWhenConnecting;
      client.disconnect();
    }
    return status;
  }

  void _onSubscribed(String topic) {
    log('[MQTT Client] Subscription confirmed for topic $topic');
    subscriptionStatus = MqttClientSubcriptionState.Idle;
    publishMessage({'"action"': '"request/device/list"'}.toString());
    publishMessage({'"action"': '"request/device/gps"'}.toString());
  }

  void _onDisconnected() {
    log('[MQTT Client] OnDisconnected client callback - Client disconnection');
    connectionState = MqttClientConnectionState.Disconnected;
    onDisconnectedCallback?.call();
  }

  void _onConnected() {
    onConnectedCallback?.call();
    connectionState = MqttClientConnectionState.Connected;
    log('[MQTT Client] OnConnected client callback - Client connected!');
    subscribeToTopic();
  }
}
