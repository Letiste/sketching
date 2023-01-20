import 'event_stream.dart';

class SelectedPathsEvent {
  static final EventStream<List<int>> instance = EventStream();
}
