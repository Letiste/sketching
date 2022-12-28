import 'package:flutter/gestures.dart';
import 'package:sketcher/eventStreams/event_stream.dart';

class ScrollEvent {
  static final EventStream<PointerScrollEvent> instance = EventStream();
}
