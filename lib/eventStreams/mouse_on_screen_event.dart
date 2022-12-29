import 'event_stream.dart';

class MouseOnScreenEvent {
  static final EventStream<bool> instance = EventStream();
}
