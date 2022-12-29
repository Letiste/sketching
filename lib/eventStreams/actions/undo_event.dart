import '../event_stream.dart';

class UndoEvent {
  static final EventStream<bool> instance = EventStream();
}
