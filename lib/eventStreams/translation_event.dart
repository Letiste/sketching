import 'dart:ui';

import 'event_stream.dart';

class TranslationEvent {
  static final EventStream<Offset> instance = EventStream(Offset.zero);
}
