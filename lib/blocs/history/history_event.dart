part of 'history_bloc.dart';

abstract class HistoryEvent extends Equatable {
  final String topic;
  final Map<String, dynamic> payload;
  const HistoryEvent(this.topic, this.payload);
}

class FetchHistory extends HistoryEvent {
  final String topic;
  final Map<String, dynamic> payload;

  FetchHistory({this.topic, this.payload}) : super(topic, payload);

  @override
  List<Object> get props => [topic, payload];
}

class WriteHistory extends HistoryEvent {
  WriteHistory(String topic, Map<String, dynamic> payload) : super(topic, payload);

  @override
  List<Object> get props => [];
}


class EraseHistory extends HistoryEvent {
  EraseHistory() : super(null, {"deviceId": null});
  @override
  List<Object> get props => [];
}

class SliceHistory extends HistoryEvent {
  final DateTime start, end;
  SliceHistory(this.start, this.end) : super(null, {"deviceId": null});

  @override
  List<Object> get props => [start, end];
}

