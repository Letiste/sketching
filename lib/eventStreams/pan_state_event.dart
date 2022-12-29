import 'package:flutter/gestures.dart';
import 'event_stream.dart';

abstract class PanState {}

class PanStarting extends PanState {
  final DragStartDetails details;

  PanStarting(this.details);
}

class PanUpdating extends PanState {
  final DragUpdateDetails details;

  PanUpdating(this.details);
}

class PanEnding extends PanState {}

class PanStateEvent {
  static final EventStream<PanState> instance = EventStream();
}
