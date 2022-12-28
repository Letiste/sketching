import 'package:sketcher/eventStreams/event_stream.dart';

enum CursorState { drawing, erasing, dragging }

class CursorStateEvent {
  static final EventStream<CursorState> instance = EventStream();
}
