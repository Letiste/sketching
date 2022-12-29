import 'event_stream.dart';

class FocusEvent {
  static final EventStream<bool> instance = EventStream();
}
