import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tracking_app/data/device_repository.dart';
import 'package:tracking_app/models/_.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  DeviceRepository deviceRepository;

  HistoryBloc(this.deviceRepository);

  @override
  HistoryState get initialState => HistoryInitial();

  @override
  Stream<HistoryState> mapEventToState(
    HistoryEvent event,
  ) async* {
    yield HistoryLoading(event.payload['deviceId'] ?? -1, state.positions);
    if (event is FetchHistory) {
      try {
        final history = await deviceRepository.fetchHistory(0);
        yield HistoryLoaded(history);
      } on NetworkError {
        yield HistoryError('An error occurs. Please try again!');
      }
    } else if (event is EraseHistory) {
      yield HistoryInitial();
    } else if (event is SliceHistory) {
      final slicedHistory = History(
        deviceId: state.deviceId,
        positions: state.positions.where(
          (p) =>
              p.timestamp.isAfter(event.start) &&
              p.timestamp.isBefore(event.end),
        ).toList(),
      );

      yield HistorySliced(
        slicedHistory,
        History(deviceId: state.deviceId, positions: state.positions),
      );
    }
  }
}
