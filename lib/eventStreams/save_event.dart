import 'event_stream.dart';

class SaveEvent {
  static final EventStream<bool> instance = EventStream();
}
