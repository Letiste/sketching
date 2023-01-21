import 'package:flutter/material.dart';
import 'package:sketcher/eventStreams/redo_action_event.dart';
import 'package:sketcher/eventStreams/undo_action_event.dart';
import 'package:sketcher/selected_area.dart';
import 'package:sketcher/sketch_line.dart';
import 'package:sketcher/undo/duplicate/duplicate_undo_action.dart';

import '../../eventStreams/current_points_event.dart';

class DuplicateRedoAction extends RedoAction {
  final SelectedArea selectedArea;
  final List<SketchLine> sketchLines;
  final double currentZoom;

  const DuplicateRedoAction({
    required this.selectedArea,
    required this.sketchLines,
    required this.currentZoom,
  });

  @override
  void redo() {
    final selectedPaths = selectedArea.selectedPathsIndex;
    if (selectedPaths == null) return;

    List<SketchLine> newSketchLines = List.from(sketchLines);
    for (final selectedPath in selectedPaths) {
      newSketchLines.add(SketchLine.from(newSketchLines[selectedPath]));
    }
    final drag = const Offset(10, 10) / currentZoom;
    selectedArea.shift(drag, newSketchLines);

    CurrentPointsEvent.instance.addEvent(newSketchLines);
  }

  @override
  UndoAction undo() {
    return DuplicateUndoAction(
      selectedArea: selectedArea,
      currentZoom: currentZoom,
      sketchLines: sketchLines,
    );
  }
}
