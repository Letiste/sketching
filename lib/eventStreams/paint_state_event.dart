import 'dart:ui';

import 'event_stream.dart';

class PaintStateEvent {
  static final EventStream<Paint> instance = EventStream(Paint());
}
