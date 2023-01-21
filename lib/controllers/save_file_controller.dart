import 'dart:convert';
import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:sketching/eventStreams/save_file_event.dart';
import 'package:sketching/eventStreams/translation_event.dart';
import 'package:sketching/eventStreams/zoom_event.dart';

import '../eventStreams/current_points_event.dart';
import '../sketch_line.dart';

class SaveFileController {
  late List<SketchLine> _currentPoints;
  late double _zoom;
  late Offset _translation;
  static void instance = SaveFileController._privateController();

  SaveFileController._privateController() {
    _setupStreams();
    SaveFileEvent.instance.stream.listen(_handleEvent);
  }

  void _handleEvent(String fileName) {
    final file = File(fileName);
    final content = {
      'currentPoints': _currentPoints,
      'zoom': _zoom,
      'translation': {
        'dx': _translation.dx,
        'dy': _translation.dy,
      },
    };
    file.writeAsStringSync(jsonEncode(content));
  }

  void _setupStreams() {
    CurrentPointsEvent.instance.stream.listen((event) => _currentPoints = event);
    ZoomEvent.instance.stream.listen((event) => _zoom = event);
    TranslationEvent.instance.stream.listen((event) => _translation = event);
  }
}
