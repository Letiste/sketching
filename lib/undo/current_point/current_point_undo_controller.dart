import 'package:rxdart/rxdart.dart';
import 'package:sketcher/eventStreams/redo_action_event.dart';
import 'package:sketcher/eventStreams/undo_action_event.dart';
import 'package:sketcher/sketch_line.dart';
import 'package:sketcher/undo/current_point/current_points_undo_action.dart';

import '../../eventStreams/current_points_event.dart';
import '../../eventStreams/cursor_state_event.dart';
import '../../eventStreams/pan_state_event.dart';
import '../../utils/tuple.dart';

class CurrentPointUndoController {
  late List<UndoAction> _undoActions;
  late List<SketchLine> _currentPoints;

  static void instance = CurrentPointUndoController._privateController();

  CurrentPointUndoController._privateController() {
    _setupStreams();
    final cursorStateStream = CursorStateEvent.instance.stream;
    final panStateStream = PanStateEvent.instance.stream.where((event) => event is PanEnding);

    panStateStream
        .withLatestFrom(
          cursorStateStream,
          (panState, cursorState) => Pair(panState, cursorState),
        )
        .where((event) => event.second is CursorDrawing || event is CursorErasing)
        .listen((_) => _handleEvent());
  }

  void _handleEvent() {
    final undoAction = CurrentPointsUndoAction(currentPoints: List.from(_currentPoints));
    List<UndoAction> newUndoActions = List.from(_undoActions)..add(undoAction);
    UndoActionEvent.instance.addEvent(newUndoActions);
    RedoActionEvent.instance.addEvent([]);
  }

  void _setupStreams() {
    UndoActionEvent.instance.stream.listen((event) => _undoActions = event);
    CurrentPointsEvent.instance.stream.listen((event) => _currentPoints = event);
  }
}
