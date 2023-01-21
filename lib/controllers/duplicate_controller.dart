import 'dart:ui';

import 'package:sketcher/eventStreams/current_points_event.dart';
import 'package:sketcher/eventStreams/duplicate_event.dart';
import 'package:sketcher/eventStreams/selected_area_event.dart';
import 'package:sketcher/eventStreams/zoom_event.dart';
import 'package:sketcher/selected_area.dart';
import 'package:sketcher/sketch_line.dart';

class DuplicateController {
  late SelectedArea _selectedArea;
  late List<SketchLine> _sketchLines;
  late double _currentZoom;

  static void instance = DuplicateController._privateController();

  DuplicateController._privateController() {
    _setupStreams();
    DuplicateEvent.instance.stream.listen((_) => _handleEvent());
  }

  void _handleEvent() {
    final selectedPaths = _selectedArea.selectedPathsIndex;
    if (selectedPaths == null) return;

    List<SketchLine> newSketchLines = List.from(_sketchLines);
    for (final selectedPath in selectedPaths) {
      newSketchLines.add(SketchLine.from(newSketchLines[selectedPath]));
    }
    final drag = const Offset(10, 10) / _currentZoom;
    _selectedArea.shift(drag, newSketchLines);

    CurrentPointsEvent.instance.addEvent(newSketchLines);
  }

  void _setupStreams() {
    SelectedAreaEvent.instance.stream.listen((event) => _selectedArea = event);
    CurrentPointsEvent.instance.stream.listen((event) => _sketchLines = event);
    ZoomEvent.instance.stream.listen((event) => _currentZoom = event);
  }
}
