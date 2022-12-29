import '../event_stream.dart';

class ResetEvent {
  static final EventStream<bool> instance = EventStream();
}
