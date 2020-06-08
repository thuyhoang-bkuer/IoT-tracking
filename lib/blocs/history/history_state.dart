part of 'history_bloc.dart';

abstract class HistoryState extends Equatable {
  final int deviceId;
  final List<Position> positions;
  const HistoryState(this.deviceId, this.positions);
}

class HistoryInitial extends HistoryState {
  const HistoryInitial() : super(-1, const []);
  @override
  List<Object> get props => [];
}

class HistoryLoading extends HistoryState {
  const HistoryLoading(int deviceId, List<Position> positions) : super(deviceId, positions);
  @override
  List<Object> get props => [];
}

class HistoryLoaded extends HistoryState {
  final History history;
  HistoryLoaded(this.history) : super(history.deviceId, history.positions);
  List<Object> get props => [history];
}

class HistoryError extends HistoryState {
  final String error;
  HistoryError(this.error) : super(-1, const []);
  @override
  List<Object> get props => [error];
}

class HistorySliced extends HistoryState {
  final History sliced;

  HistorySliced(this.sliced, History originHistory) : super(originHistory.deviceId, originHistory.positions);

  @override
  List<Object> get props => [sliced];
}