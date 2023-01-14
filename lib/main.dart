import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sketcher/controllers/cursor_aspect_controller.dart';
import 'package:sketcher/controllers/focus_controller.dart';
import 'package:sketcher/controllers/reset_controller.dart';
import 'package:sketcher/controllers/paint_controller.dart';
import 'package:sketcher/controllers/redo_controller.dart';
import 'package:sketcher/controllers/save_controller.dart';
import 'package:sketcher/controllers/save_file_controller.dart';
import 'package:sketcher/controllers/undo_controller.dart';
import 'package:sketcher/controllers/pencil_color_controller.dart';
import 'package:sketcher/eventStreams/current_points_event.dart';
import 'package:sketcher/eventStreams/translation_event.dart';
import 'package:sketcher/eventStreams/zoom_event.dart';
import 'package:sketcher/sketch_line.dart';
import 'controllers/drag_controller.dart';
import 'controllers/draw_controller.dart';
import 'controllers/zoom_controller.dart';
import 'sketcher.dart';

void main(List<String> args) {
  setupControllers();
  runApp(MyApp(args: args));
}

void setupControllers() {
  ZoomController.instance;
  DragController.instance;
  DrawController.instance;
  PaintController.instance;
  UndoController.instance;
  RedoController.instance;
  FocusController.instance;
  ResetController.instance;
  PencilColorController.instance;
  CursorAspectController.instance;
  SaveController.instance;
  SaveFileController.instance;
}

class MyApp extends StatelessWidget {
  final List<String> args;

  MyApp({super.key, required this.args}) {
    _handleArgs();
  }

  void _handleArgs() {
    if (args.isNotEmpty) {
    File file = File(args.first);
    final content = Map<String, dynamic>.from(jsonDecode(file.readAsStringSync()));
    CurrentPointsEvent.instance.addEvent(
      List<Map<String, dynamic>>.from(content["currentPoints"])
          .map(
            (currentPoint) => SketchLine.fromJson(currentPoint),
          )
          .toList(),
    );
    ZoomEvent.instance.addEvent(content["zoom"]);
    TranslationEvent.instance.addEvent(
      Offset(content["translation"]["dx"], content["translation"]["dy"]),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Sketcher(),
    );
  }
}
