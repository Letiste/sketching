import 'package:flutter/gestures.dart';
import 'event_stream.dart';

class ScrollEvent {
  static final EventStream<PointerScrollEvent> instance = EventStream();
}
