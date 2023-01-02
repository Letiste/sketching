import 'dart:convert';
import 'dart:io';

import 'package:sketcher/eventStreams/save_file_event.dart';

import '../eventStreams/current_points_event.dart';
import '../sketch_line.dart';

class SaveFileController {
  late List<SketchLine> _currentPoints;
  static void instance = SaveFileController._privateController();

  SaveFileController._privateController() {
    _setupStreams();
    SaveFileEvent.instance.stream.listen(_handleEvent);
  }

  void _handleEvent(String fileName) {
    final file = File(fileName);
    file.writeAsStringSync(jsonEncode(_currentPoints));
  }

  void _setupStreams() {
    CurrentPointsEvent.instance.stream.listen((event) => _currentPoints = event);
  }
}
