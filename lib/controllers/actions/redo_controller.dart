import 'package:sketcher/eventStreams/redo_points_event.dart';
import 'package:sketcher/sketch_line.dart';

import '../../eventStreams/current_points_event.dart';
import '../../eventStreams/actions/redo_event.dart';

class RedoController {
  late List<SketchLine> _currentPoints;
  late List<SketchLine> _redoPoints;

  static void instance = RedoController._privateController();

  RedoController._privateController() {
    _setupStreams();
    RedoEvent.instance.stream.listen((_) => _handleEvent());
  }

  void _handleEvent() {
    if (_redoPoints.isNotEmpty) {
      List<SketchLine> newPoints = List.from(_currentPoints)..add(_redoPoints.last);
      List<SketchLine> newRedoPoints = List.from(_redoPoints)..removeLast();
      CurrentPointsEvent.instance.addEvent(newPoints);
      RedoPointsEvent.instance.addEvent(newRedoPoints);
    }
  }

  void _setupStreams() {
    CurrentPointsEvent.instance.stream.listen((event) => _currentPoints = event);
    RedoPointsEvent.instance.stream.listen((event) => _redoPoints = event);
  }
}
