import 'package:flutter/material.dart';
import 'package:sketcher/eventStreams/event_stream.dart';

class PencilColorEvent {
  static final EventStream<Color> instance = EventStream();
}
