import 'package:flutter/material.dart';

import 'event_stream.dart';

class CursorAspectEvent {
  static final EventStream<Widget> instance = EventStream();
}
