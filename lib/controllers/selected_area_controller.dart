import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sketcher/eventStreams/current_points_event.dart';
import 'package:sketcher/eventStreams/selected_area_event.dart';
import 'package:sketcher/selected_area.dart';
import 'package:sketcher/sketch_line.dart';

import '../eventStreams/cursor_state_event.dart';
import '../eventStreams/pan_state_event.dart';
import '../eventStreams/translation_event.dart';
import '../eventStreams/zoom_event.dart';
import '../utils/tuple.dart';

class SelectedAreaController {
  late SelectedArea _selectedArea;
  late List<SketchLine> _sketchLines;
  late Offset _currentTranslation;
  late double _currentZoom;

  static void instance = SelectedAreaController._privateController();

  SelectedAreaController._privateController() {
    _setupStreams();
    final cursorStateStream = CursorStateEvent.instance.stream;
    final panStateStream = PanStateEvent.instance.stream;
    CombineLatestStream.combine2(
      cursorStateStream,
      panStateStream,
      (cursorState, panState) => Pair(cursorState, panState),
    ).listen(_handleEvent);
  }

  void _handleEvent(Pair<CursorState, PanState> event) {
    if (event.first is CursorInSelectingArea) return;
    if (event.first is! CursorSelecting) {
      SelectedAreaEvent.instance.addEvent(SelectedArea.empty());
      return;
    }
    final panState = event.second;
    if (panState is PanStarting) {
      SelectedAreaEvent.instance.addEvent(SelectedArea.empty());
    }
    if (panState is PanUpdating) {
      SelectedArea newSelectedArea = _updateSelectedArea(panState);
      SelectedAreaEvent.instance.addEvent(newSelectedArea);
    }
    if (panState is PanEnding) {
      _selectSketchLines();
    }
  }

  void _selectSketchLines() {
    final selectedPathsIndex = _selectedArea.getSelectedPathsIndex(_sketchLines);
    for (final selectedPathIndex in selectedPathsIndex) {
      _sketchLines[selectedPathIndex].paint.color = Colors.yellow;
    }
    CurrentPointsEvent.instance.addEvent(_sketchLines);
  }

  SelectedArea _updateSelectedArea(PanUpdating panState) {
    final mousePosition = _getPointPosition(panState.details.localPosition);
    SelectedArea newSelectedArea;
    if (_selectedArea.isEmpty) {
      newSelectedArea = SelectedArea(
        firstCorner: mousePosition,
        secondCorner: mousePosition,
      );
    } else {
      newSelectedArea = SelectedArea(
        firstCorner: _selectedArea.firstCorner,
        secondCorner: mousePosition,
      );
    }
    return newSelectedArea;
  }

  Offset _getPointPosition(Offset cursorWindowPosition) {
    return (cursorWindowPosition - _currentTranslation) / _currentZoom;
  }

  void _setupStreams() {
    SelectedAreaEvent.instance.stream.listen((event) => _selectedArea = event);
    CurrentPointsEvent.instance.stream.listen((event) => _sketchLines = event);
    ZoomEvent.instance.stream.listen((event) => _currentZoom = event);
    TranslationEvent.instance.stream.listen((event) => _currentTranslation = event);
  }
}
