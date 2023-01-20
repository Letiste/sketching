import 'dart:ui';

import 'package:rxdart/rxdart.dart';
import 'package:sketcher/eventStreams/current_points_event.dart';
import 'package:sketcher/eventStreams/cursor_state_event.dart';
import 'package:sketcher/eventStreams/pan_state_event.dart';
import 'package:sketcher/eventStreams/selected_area_event.dart';
import 'package:sketcher/eventStreams/selected_paths_event.dart';
import 'package:sketcher/eventStreams/zoom_event.dart';
import 'package:sketcher/selected_area.dart';
import 'package:sketcher/sketch_line.dart';

import '../utils/tuple.dart';

class SelectedPathsController {
  late List<int> _selectedPaths;
  late List<SketchLine> _sketchLines;
  late SelectedArea _selectedArea;
  late double _currentZoom;

  static void instance = SelectedPathsController._privateController();

  SelectedPathsController._privateController() {
    _setupStreams();
    final cursorStateStream = CursorStateEvent.instance.stream;
    final panStateStream = PanStateEvent.instance.stream;
    CombineLatestStream.combine2(
      cursorStateStream,
      panStateStream,
      (cursorState, panState) => Pair(cursorState, panState),
    )
        .where((event) => event.first is CursorInSelectingArea)
        .where((event) => event.second is PanUpdating)
        .map((event) => (event.second as PanUpdating).details.delta)
        .listen(_handleEvent);
  }

  void _handleEvent(Offset drag) {
    for (final selectedPath in _selectedPaths) {
      _sketchLines[selectedPath].shift(drag / _currentZoom);
    }
    _selectedArea.shift(drag / _currentZoom);
    CurrentPointsEvent.instance.addEvent(_sketchLines);
  }

  void _setupStreams() {
    SelectedPathsEvent.instance.stream.listen((event) => _selectedPaths = event);
    CurrentPointsEvent.instance.stream.listen((event) => _sketchLines = event);
    SelectedAreaEvent.instance.stream.listen((event) => _selectedArea = event);
    ZoomEvent.instance.stream.listen((event) => _currentZoom = event);
  }
}
