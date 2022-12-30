import 'package:flutter/material.dart';
import 'event_stream.dart';

class PencilColorEvent {
  static final EventStream<Color> instance = EventStream(Colors.grey.shade100);
}
