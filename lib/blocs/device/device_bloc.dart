import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tracking_app/data/_.dart';
import 'package:tracking_app/models/_.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final DeviceRepository deviceRepository;

  DeviceBloc(this.deviceRepository);

  @override
  DeviceState get initialState => DeviceInitial([]);

  @override
  Stream<DeviceState> mapEventToState(
    DeviceEvent event,
  ) async* {
    yield DeviceLoading(state.devices);
    if (event is FetchDevices) {
      try {
        final devices = await deviceRepository.fetchDevices(event.payload);

        yield DeviceLoaded(devices);
      } on NetworkError {
        yield DeviceError(
            error: "There was an error occurs. Please try again!");
      }
    } else if (event is SubcribePosition) {
      // payload: {
      //    index:
      //    lat:
      //    long:
      // }
      try {
        final Map<String, dynamic> jsonMap = event.payload;
        final position = state.devices[jsonMap['index']].position = Position(
          latitude: jsonMap['latitude'],
          longitude: jsonMap['longitude'],
          timestamp: DateTime.now(),
        );

        deviceRepository.postPosition(jsonMap['deviceId'], position);

        yield DeviceLoaded(state.devices);
      } on NetworkError {
        yield DeviceError(
            error: "There was an error occurs. Please try again!");
      }
    } else if (event is PutDevice) {
      final Map<String, dynamic> jsonMap = event.payload;

      if (!jsonMap.containsKey('index') && !jsonMap.containsKey('deviceId')) {
        yield DeviceLoaded(state.devices);
      }

      final devices = state.devices;
      final updated = jsonMap.containsKey('index')
          ? devices[jsonMap['index']]
          : devices.firstWhere((device) => device.id == jsonMap['deviceId'], orElse: () => null);
      final status = jsonMap.containsKey('status')
          ? (jsonMap['status'] ? Power.On : Power.Off)
          : updated?.status;
      final policies = jsonMap.containsKey('policies')
          ? jsonMap['policies']
          : updated?.policies;

      updated.status = status;
      updated.policies = policies;

      yield DeviceLoaded(devices);
    } else if (event is LocateDevice) {
      final Map<String, dynamic> jsonMap = event.payload;

      state.devices[jsonMap['index']].position = Position(
        latitude: jsonMap['latitude'],
        longitude: jsonMap['longitude'],
      );
      yield DeviceLoaded(state.devices);
    } else if (event is ClearDevices) {
      yield DeviceInitial([]);
    }
  }
}
