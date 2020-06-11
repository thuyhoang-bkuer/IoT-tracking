part of 'privacy_bloc.dart';

abstract class PrivacyState extends Equatable {
  final String deviceId;
  const PrivacyState(this.deviceId);
}

class PrivacyInitial extends PrivacyState {
  PrivacyInitial(String deviceId) : super(deviceId);
  @override
  List<Object> get props => [];
}

class PrivacyLoading extends PrivacyState {
  PrivacyLoading(String deviceId) : super(deviceId);

  @override
  List<Object> get props => [];
}

class PrivacyLoaded extends PrivacyState {
  final List<Privacy> policies;

  PrivacyLoaded(String deviceId, {this.policies}) : super(deviceId);

  @override
  List<Object> get props => [policies];
}

class PrivacyError extends PrivacyState {
  final String error;

  PrivacyError(String deviceId, {this.error}) : super(deviceId);

  @override
  List<Object> get props => [error];
  
}