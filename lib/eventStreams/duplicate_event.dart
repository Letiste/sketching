import 'event_stream.dart';

class DuplicateEvent {
  static final EventStream<bool> instance = EventStream();
}
