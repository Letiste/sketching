import 'dart:ui';

import 'package:sketcher/eventStreams/event_stream.dart';

class TranslateEvent {
  static final EventStream<Offset> instance = EventStream();
}
