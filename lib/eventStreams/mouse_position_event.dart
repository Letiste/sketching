import 'package:flutter/gestures.dart';
import 'event_stream.dart';

class MousePositionEvent {
  static final EventStream<Offset> instance = EventStream();
}
