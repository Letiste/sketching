import 'event_stream.dart';

class RedoEvent {
  static final EventStream<bool> instance = EventStream();
}
