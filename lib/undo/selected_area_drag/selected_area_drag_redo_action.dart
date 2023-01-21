import 'package:flutter/material.dart';
import 'package:sketching/eventStreams/redo_action_event.dart';
import 'package:sketching/eventStreams/selected_area_event.dart';
import 'package:sketching/eventStreams/undo_action_event.dart';
import 'package:sketching/selected_area.dart';
import 'package:sketching/sketch_line.dart';
import 'package:sketching/undo/selected_area_drag/selected_area_drag_undo_action.dart';

import '../../eventStreams/current_points_event.dart';

class SelectedAreaDragRedoAction extends RedoAction {
  final List<SketchLine> currentPoints;
  final Offset drag;
  final SelectedArea selectedArea;

  const SelectedAreaDragRedoAction({
    required this.selectedArea,
    required this.currentPoints,
    required this.drag,
  });

  @override
  void redo() {
    List<SketchLine> newPoints = List.from(currentPoints);
    selectedArea.shift(drag, newPoints);
    CurrentPointsEvent.instance.addEvent(newPoints);
    SelectedAreaEvent.instance.addEvent(SelectedArea.empty());
  }

  @override
  UndoAction undo() {
    return SelectedAreaDragUndoAction(
      drag: drag,
      currentPoints: currentPoints,
      selectedArea: selectedArea,
    );
  }
}
