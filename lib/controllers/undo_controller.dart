import 'package:sketcher/eventStreams/redo_points_event.dart';
import 'package:sketcher/eventStreams/undo_event.dart';
import 'package:sketcher/sketch_line.dart';

import '../eventStreams/current_points_event.dart';

class UndoController {
  late List<SketchLine> _currentPoints;
  late List<SketchLine> _redoPoints;

  static void instance = UndoController._privateController();

  UndoController._privateController() {
    _setupStreams();
    UndoEvent.instance.stream.listen((_) => _handleEvent());
  }

  void _handleEvent() {
    if (_currentPoints.isNotEmpty) {
      List<SketchLine> newPoints = List.from(_currentPoints)..removeLast();
      List<SketchLine> newRedoPoints = List.from(_redoPoints)..add(_currentPoints.last);
      CurrentPointsEvent.instance.addEvent(newPoints);
      RedoPointsEvent.instance.addEvent(newRedoPoints);
    }
  }

  void _setupStreams() {
    CurrentPointsEvent.instance.stream.listen((event) => _currentPoints = event);
    RedoPointsEvent.instance.stream.listen((event) => _redoPoints = event);
  }
}
