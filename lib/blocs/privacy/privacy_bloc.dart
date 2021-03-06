import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tracking_app/data/device_repository.dart';
import 'package:tracking_app/models/_.dart';

part 'privacy_event.dart';
part 'privacy_state.dart';

class PrivacyBloc extends Bloc<PrivacyEvent, PrivacyState> {
  final DeviceRepository deviceRepository;

  PrivacyBloc(this.deviceRepository);

  @override
  PrivacyState get initialState => PrivacyInitial(null);

  @override
  Stream<PrivacyState> mapEventToState(
    PrivacyEvent event,
  ) async* {
    final deviceId = event.payload['deviceId'].toString();
    yield PrivacyLoading(deviceId);

    try {
      if (event is FetchPrivacy) {
        final privacy = await deviceRepository.fetchPrivacy(deviceId);
        yield PrivacyLoaded(deviceId, policies: privacy);
      }
      else if (event is PostPrivacy) {
        final privacy = Privacy.fromMap(event.payload['privacy']);
        await deviceRepository.postPolicy(privacy);
        final policies = await deviceRepository.fetchPrivacy(deviceId);

        yield PrivacyLoaded(deviceId, policies: policies);
      }
      else if (event is RemovePrivacy) {
        await deviceRepository.removePrivacy(event.payload['_id']);
        final policies = await deviceRepository.fetchPrivacy(deviceId);

        yield PrivacyLoaded(deviceId, policies: policies);
      }
    }
    on NetworkError {
      yield PrivacyError(deviceId, error: "An error occurs in $deviceId's privacy. Please try again.");
    }
  }
}
