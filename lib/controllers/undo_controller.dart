import 'package:flutter/cupertino.dart';
import 'package:sketching/eventStreams/redo_action_event.dart';
import 'package:sketching/eventStreams/undo_action_event.dart';
import 'package:sketching/eventStreams/undo_event.dart';

class UndoController {
  late List<UndoAction> _undoActions;
  late List<RedoAction> _redoActions;

  static void instance = UndoController._privateController();

  UndoController._privateController() {
    _setupStreams();
    UndoEvent.instance.stream.listen((_) => _handleEvent());
  }

  void _handleEvent() {
    if (_undoActions.isEmpty) return;
    List<UndoAction> newUndoActions = List.from(_undoActions);
    final undoAction = newUndoActions.removeLast();
    debugPrint('Undo from ${undoAction.runtimeType}');
    undoAction.undo();
    UndoActionEvent.instance.addEvent(newUndoActions);
    List<RedoAction> newRedoActions = List.from(_redoActions)..add(undoAction.redo());
    RedoActionEvent.instance.addEvent(newRedoActions);
  }

  void _setupStreams() {
    UndoActionEvent.instance.stream.listen((event) => _undoActions = event);
    RedoActionEvent.instance.stream.listen((event) => _redoActions = event);
  }
}
