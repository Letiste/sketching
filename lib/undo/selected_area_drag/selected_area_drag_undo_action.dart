import 'package:flutter/material.dart';
import 'package:sketcher/eventStreams/redo_action_event.dart';
import 'package:sketcher/eventStreams/selected_area_event.dart';
import 'package:sketcher/eventStreams/undo_action_event.dart';
import 'package:sketcher/selected_area.dart';
import 'package:sketcher/sketch_line.dart';
import 'package:sketcher/undo/selected_area_drag/selected_area_drag_redo_action.dart';

import '../../eventStreams/current_points_event.dart';

class SelectedAreaDragUndoAction extends UndoAction {
  final List<SketchLine> currentPoints;
  final Offset drag;
  final SelectedArea selectedArea;

  const SelectedAreaDragUndoAction({
    required this.selectedArea,
    required this.currentPoints,
    required this.drag,
  });

  @override
  void undo() {
    List<SketchLine> newPoints = List.from(currentPoints);
    selectedArea.shift(-drag, newPoints);
    CurrentPointsEvent.instance.addEvent(newPoints);
    SelectedAreaEvent.instance.addEvent(SelectedArea.empty());
  }

  @override
  RedoAction redo() {
    return SelectedAreaDragRedoAction(
      currentPoints: currentPoints,
      drag: drag,
      selectedArea: selectedArea,
    );
  }
}
