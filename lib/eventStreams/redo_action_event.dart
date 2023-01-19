import 'package:sketcher/eventStreams/undo_action_event.dart';

import 'event_stream.dart';

abstract class RedoAction {
  const RedoAction();
  void redo();
  UndoAction undo();
}

class RedoActionEvent {
  static final EventStream<List<RedoAction>> instance = EventStream([]);
}
