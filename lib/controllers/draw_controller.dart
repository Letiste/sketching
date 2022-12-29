import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sketcher/eventStreams/paint_state_event.dart';
import 'package:sketcher/eventStreams/redo_points_event.dart';

import '../eventStreams/current_points_event.dart';
import '../eventStreams/cursor_state_event.dart';
import '../eventStreams/pan_state_event.dart';
import '../eventStreams/translation_event.dart';
import '../eventStreams/zoom_event.dart';
import '../sketch_line.dart';
import '../utils/tuple.dart';

class DrawController {
  late List<SketchLine> _currentPoints;
  late Offset _currentTranslation;
  late double _currentZoom;
  late Paint _currentPaint;

  static void instance = DrawController._privateController();

  DrawController._privateController() {
    _setupStreams();
    final cursorStateStream = CursorStateEvent.instance.stream;
    final panStateStream = PanStateEvent.instance.stream;
    CombineLatestStream.combine2(
      cursorStateStream,
      panStateStream,
      (cursorState, panState) => Pair(cursorState, panState),
    )
        .where((event) => event.first is CursorDrawing || event.first is CursorErasing)
        .map((event) => event.second)
        .listen(_handleEvent);
  }

  void _handleEvent(PanState panState) {
    RedoPointsEvent.instance.addEvent([]);
    if (panState is PanStarting) {
      _handlePanStarting(panState);
    }
    if (panState is PanUpdating) {
      _handlePanUpdating(panState);
    }
  }

  void _handlePanStarting(PanStarting panState) {
    final newPoints = SketchLine(
      points: [_getPointPosition(panState.details.localPosition)],
      scale: _currentZoom,
      paint: _currentPaint,
    );
    CurrentPointsEvent.instance.addEvent(_currentPoints..add(newPoints));
  }

  void _handlePanUpdating(PanUpdating panState) {
    List<SketchLine> newPoints = List.from(_currentPoints);
    final newLine = SketchLine.from(newPoints.last);
    newLine.addPoint(_getPointPosition(panState.details.localPosition));
    newPoints.last = newLine;
    CurrentPointsEvent.instance.addEvent(newPoints);
  }

  Offset _getPointPosition(Offset cursorWindowPosition) {
    return (cursorWindowPosition - _currentTranslation) / _currentZoom;
  }

  void _setupStreams() {
    CurrentPointsEvent.instance.stream.listen((event) => _currentPoints = event);
    ZoomEvent.instance.stream.listen((event) => _currentZoom = event);
    TranslationEvent.instance.stream.listen((event) => _currentTranslation = event);
    PaintStateEvent.instance.stream.listen((event) => _currentPaint = event);
  }
}
