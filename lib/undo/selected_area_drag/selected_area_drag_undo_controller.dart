import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sketching/eventStreams/redo_action_event.dart';
import 'package:sketching/eventStreams/selected_area_event.dart';
import 'package:sketching/eventStreams/undo_action_event.dart';
import 'package:sketching/eventStreams/zoom_event.dart';
import 'package:sketching/selected_area.dart';
import 'package:sketching/sketch_line.dart';
import 'package:sketching/undo/selected_area_drag/selected_area_drag_undo_action.dart';

import '../../eventStreams/current_points_event.dart';
import '../../eventStreams/cursor_state_event.dart';
import '../../eventStreams/pan_state_event.dart';
import '../../utils/tuple.dart';

class SelectedAreaDragUndoController {
  late List<UndoAction> _undoActions;
  late List<SketchLine> _currentPoints;
  late SelectedArea _selectedArea;
  late double _currentZoom;
  Offset _drag = Offset.zero;

  static void instance = SelectedAreaDragUndoController._privateController();

  SelectedAreaDragUndoController._privateController() {
    _setupStreams();
    final cursorStateStream = CursorStateEvent.instance.stream;
    final panStateStream = PanStateEvent.instance.stream.where((event) => event is PanEnding);
    panStateStream.withLatestFrom(cursorStateStream, (t, s) => Pair(t, s))
    .where((event) => event.second is CursorInSelectingArea)
    .listen((_) => _handleEvent());
  }

  void _handleEvent() {
    final undoAction = SelectedAreaDragUndoAction(
      currentPoints: _currentPoints,
      selectedArea: _selectedArea,
      drag: _drag,
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
    final panStateStream = PanStateEvent.instance.stream;
    final cursorStateStream = CursorStateEvent.instance.stream;
    panStateStream.withLatestFrom(cursorStateStream,
      (panState, cursorState) => Pair(panState, cursorState),
    )
        .where((event) => event.second is CursorInSelectingArea)
        .map((event) => event.first)
        .listen((event) {
      if (event is PanStarting) {
        _drag = Offset.zero;
      }
      if (event is PanUpdating) {
        _drag += event.details.delta / _currentZoom;
      }
    });
  }
}
