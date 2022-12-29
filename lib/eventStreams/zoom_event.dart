import 'event_stream.dart';

class ZoomEvent {
  static final EventStream<double> instance = EventStream(1);
}
