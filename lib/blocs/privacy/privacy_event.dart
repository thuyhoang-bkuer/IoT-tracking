part of 'privacy_bloc.dart';

abstract class PrivacyEvent extends Equatable {
  final String topic;
  final Map<String, dynamic> payload;
  const PrivacyEvent(this.topic, this.payload);
}

class FetchPrivacy extends PrivacyEvent {
  FetchPrivacy(String topic, Map<String, dynamic> payload)
      : super(topic, payload);
  @override
  List<Object> get props => [];
}

class PostPrivacy extends PrivacyEvent {
  PostPrivacy(String topic, Map<String, dynamic> payload)
      : super(topic, payload);
  @override
  List<Object> get props => [];
}

class RemovePrivacy extends PrivacyEvent {
  RemovePrivacy(String topic, Map<String, dynamic> payload)
      : super(topic, payload);
  @override
  List<Object> get props => [];
}
