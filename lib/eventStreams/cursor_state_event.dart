import 'event_stream.dart';

abstract class CursorState {}

class CursorDrawing extends CursorState {}

class CursorErasing extends CursorState {}

class CursorDragging extends CursorState {}

class CursorSelecting extends CursorState {}

class CursorStateEvent {
  static final EventStream<CursorState> instance = EventStream(CursorDrawing());
}
