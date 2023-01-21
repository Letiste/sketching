import 'package:sketching/eventStreams/redo_action_event.dart';
import 'package:sketching/eventStreams/undo_action_event.dart';
import 'package:sketching/sketch_line.dart';
import 'package:sketching/undo/current_point/current_points_redo_action.dart';

import '../../eventStreams/current_points_event.dart';

class CurrentPointsUndoAction extends UndoAction {
  final List<SketchLine> currentPoints;

  const CurrentPointsUndoAction({required this.currentPoints});

  @override
  void undo() {
    List<SketchLine> newPoints = List.from(currentPoints)..removeLast();
    CurrentPointsEvent.instance.addEvent(newPoints);
  }

  @override
  RedoAction redo() {
    return CurrentPointsRedoAction(previousPoints: currentPoints);
  }
}
