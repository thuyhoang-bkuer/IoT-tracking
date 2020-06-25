import 'dart:async';

import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:tracking_app/data/device_repository.dart';
import 'package:tracking_app/models/_.dart';
import 'package:tracking_app/mqtt/mqtt_wrapper.dart';

part 'mqtt_event.dart';
part 'mqtt_state.dart';

class MqttBloc extends Bloc<MqttEvent, MqttState> {
  MqttClientWrapper mqttClientWrapper;

  @override
  MqttState get initialState => MqttUnitial();

  @override
  Stream<MqttState> mapEventToState(
    MqttEvent event,
  ) async* {
    yield MqttLoading();

    try {
      if (event is MqttInitialize) {
        mqttClientWrapper = event.mqttClientWrapper;
        yield MqttInitial();
      }
      else if (event is MqttPublish) {
        if (state is MqttUnitial) {
          throw Error();
        }

        mqttClientWrapper.publishMessage(event.topic.toString(), json.encode(event.payload));
      }
      else if (event is MqttConnect) {
        if (state is MqttUnitial) {
          throw Error();
        }
        final mqttConfig = MqttConfig(
          serverUri: event.payload['serverUri'],
          port: event.payload['port'],
          username: event.payload['username'],
          password: event.payload['password'],
          topicName: event.payload['topic'],
          clientIdentifier: 'shin.re',
          keepAlivePeriod: 20,
          usedQoS: MqttQos.atLeastOnce
        );
        final response = await mqttClientWrapper.prepareMqttClient(mqttConfig);

        if (response.state == MqttConnectionState.connected) {
          yield MqttConnected();
        }
        else yield MqttInitial();

      } else if (event is MqttDisconnecting) {
        mqttClientWrapper.client.disconnect();
        await Future.delayed(Duration(milliseconds: 500));
        yield MqttInitial();
      }
      else if (event is MqttDisconnected) {
        yield MqttInitial();
      }
    } on NetworkError {
      yield MqttError('Network error!');
    } on Error {
      yield MqttError('MqttClient was not initialized!');
    }
  }
}
