import 'event_stream.dart';

class SaveFileEvent {
  static final EventStream<String> instance = EventStream();
}
