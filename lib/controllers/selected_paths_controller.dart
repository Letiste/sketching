import 'dart:ui';

import 'package:rxdart/rxdart.dart';
import 'package:sketching/eventStreams/current_points_event.dart';
import 'package:sketching/eventStreams/cursor_state_event.dart';
import 'package:sketching/eventStreams/pan_state_event.dart';
import 'package:sketching/eventStreams/selected_area_event.dart';
import 'package:sketching/eventStreams/zoom_event.dart';
import 'package:sketching/selected_area.dart';
import 'package:sketching/sketch_line.dart';

import '../utils/tuple.dart';

class SelectedPathsController {
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
    _selectedArea.shift(drag / _currentZoom, _sketchLines);
    CurrentPointsEvent.instance.addEvent(_sketchLines);
  }

  void _setupStreams() {
    CurrentPointsEvent.instance.stream.listen((event) => _sketchLines = event);
    SelectedAreaEvent.instance.stream.listen((event) => _selectedArea = event);
    ZoomEvent.instance.stream.listen((event) => _currentZoom = event);
  }
}
