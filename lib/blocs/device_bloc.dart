import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
        final devices = await deviceRepository.fetchDevices(event.topic, event.payload);
        
        yield DeviceLoaded(devices);
      }
      on NetworkError {
        log(state.toString());
        yield DeviceError(error: "There was an error occurs. Please try again!");
      }
    }
    else if (event is GetCoordinate) {
      
    }
    else if (event is PutDevice) {
      final Map<String, dynamic> jsonMap = json.decode(event.payload);
      final int id = jsonMap['id'];
      final Power status = jsonMap['status'] ? Power.On : Power.Off;
      state.devices[id].status = status;

      yield DeviceLoaded(state.devices);
    }
  }
}
