import 'package:sketching/eventStreams/duplicate_event.dart';
import 'package:sketching/eventStreams/redo_action_event.dart';
import 'package:sketching/eventStreams/selected_area_event.dart';
import 'package:sketching/eventStreams/undo_action_event.dart';
import 'package:sketching/eventStreams/zoom_event.dart';
import 'package:sketching/selected_area.dart';
import 'package:sketching/sketch_line.dart';
import 'package:sketching/undo/duplicate/duplicate_undo_action.dart';

import '../../eventStreams/current_points_event.dart';

class DuplicateUndoController {
  late List<UndoAction> _undoActions;
  late List<SketchLine> _currentPoints;
  late SelectedArea _selectedArea;
  late double _currentZoom;

  static void instance = DuplicateUndoController._privateController();

  DuplicateUndoController._privateController() {
    _setupStreams();
    DuplicateEvent.instance.stream.listen((_) => _handleEvent());
  }

  void _handleEvent() {
    final selectedPaths = _selectedArea.selectedPathsIndex;
    if (selectedPaths == null || selectedPaths.last >= _currentPoints.length) return;

    final undoAction = DuplicateUndoAction(
      selectedArea: _selectedArea,
      currentZoom: _currentZoom,
      sketchLines: _currentPoints,
    );
    List<UndoAction> newUndoActions = List.from(_undoActions)..add(undoAction);
    UndoActionEvent.instance.addEvent(newUndoActions);
    RedoActionEvent.instance.addEvent([]);
  }

  void _setupStreams() {
    UndoActionEvent.instance.stream.listen((event) => _undoActions = event);
    CurrentPointsEvent.instance.stream.listen((event) => _currentPoints = event);
    SelectedAreaEvent.instance.stream.listen((event) => _selectedArea = event);
    ZoomEvent.instance.stream.listen((event) => _currentZoom = event);
  }
}
