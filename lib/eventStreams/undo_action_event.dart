import 'package:sketcher/eventStreams/redo_action_event.dart';

import 'event_stream.dart';

abstract class UndoAction {
  const UndoAction();
  void undo();
  RedoAction redo();
}

class UndoActionEvent {
  static final EventStream<List<UndoAction>> instance = EventStream([]);
}
