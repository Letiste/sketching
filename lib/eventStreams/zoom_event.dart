import 'package:sketcher/eventStreams/event_stream.dart';

class ZoomEvent {
  static final EventStream<double> instance = EventStream();
}
