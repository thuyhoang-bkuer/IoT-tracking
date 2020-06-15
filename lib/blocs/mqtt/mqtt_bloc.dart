import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tracking_app/data/device_repository.dart';
import 'package:tracking_app/mqtt/mqtt_wrapper.dart';

part 'mqtt_event.dart';
part 'mqtt_state.dart';

class MqttBloc extends Bloc<MqttEvent, MqttState> {
  final MqttClientWrapper mqttClientWrapper;

  MqttBloc(this.mqttClientWrapper);

  @override
  MqttState get initialState => MqttInitial();

  @override
  Stream<MqttState> mapEventToState(
    MqttEvent event,
  ) async* {
    yield MqttLoading();

    try {
      if (event is MqttConnect) {
        await Future.delayed(Duration(seconds: 3));
        yield MqttConnected();
      }
      else if (event is MqttDisconnect) {
        await Future.delayed(Duration(seconds: 3));
        yield MqttInitial();
      }
    } on NetworkError {
      yield MqttError();
    }
  }
}
