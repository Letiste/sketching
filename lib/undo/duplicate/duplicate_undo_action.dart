import 'package:flutter/material.dart';
import 'package:sketcher/eventStreams/redo_action_event.dart';
import 'package:sketcher/eventStreams/undo_action_event.dart';
import 'package:sketcher/selected_area.dart';
import 'package:sketcher/sketch_line.dart';
import 'package:sketcher/undo/duplicate/duplicate_redo_action.dart';

import '../../eventStreams/current_points_event.dart';

class DuplicateUndoAction extends UndoAction {
  final SelectedArea selectedArea;
  final List<SketchLine> sketchLines;
  final double currentZoom;

  const DuplicateUndoAction({
    required this.selectedArea,
    required this.sketchLines,
    required this.currentZoom,
  });

  @override
  void undo() {
    selectedArea.shiftArea(const Offset(-10, -10) / currentZoom);
    CurrentPointsEvent.instance.addEvent(sketchLines);
  }

  @override
  RedoAction redo() {
    return DuplicateRedoAction(
      selectedArea: selectedArea,
      currentZoom: currentZoom,
      sketchLines: sketchLines,
    );
  }
}
