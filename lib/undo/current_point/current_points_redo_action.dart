import 'package:sketching/eventStreams/redo_action_event.dart';
import 'package:sketching/eventStreams/undo_action_event.dart';
import 'package:sketching/sketch_line.dart';
import 'package:sketching/undo/current_point/current_points_undo_action.dart';

import '../../eventStreams/current_points_event.dart';

class CurrentPointsRedoAction extends RedoAction {
  final List<SketchLine> previousPoints;

  const CurrentPointsRedoAction({required this.previousPoints});

  @override
  void redo() {
    CurrentPointsEvent.instance.addEvent(previousPoints);
  }

  @override
  UndoAction undo() {
    return CurrentPointsUndoAction(currentPoints: previousPoints);
  }
}
