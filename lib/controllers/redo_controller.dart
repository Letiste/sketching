import 'package:sketcher/eventStreams/redo_action_event.dart';
import 'package:sketcher/eventStreams/undo_action_event.dart';

import '../eventStreams/redo_event.dart';

class RedoController {
  late List<RedoAction> _redoActions;
  late List<UndoAction> _undoActions;

  static void instance = RedoController._privateController();

  RedoController._privateController() {
    _setupStreams();
    RedoEvent.instance.stream.listen((_) => _handleEvent());
  }

  void _handleEvent() {
    if (_redoActions.isEmpty) return;
    List<RedoAction> newRedoActions = List.from(_redoActions);
    final redoAction = newRedoActions.removeLast();
    redoAction.redo();
    RedoActionEvent.instance.addEvent(newRedoActions);
    List<UndoAction> newUndoActions = List.from(_undoActions)..add(redoAction.undo());
    UndoActionEvent.instance.addEvent(newUndoActions);
  }

  void _setupStreams() {
    RedoActionEvent.instance.stream.listen((event) => _redoActions = event);
    UndoActionEvent.instance.stream.listen((event) => _undoActions = event);
  }
}
