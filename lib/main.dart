import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sketching/controllers/cursor_aspect_controller.dart';
import 'package:sketching/controllers/duplicate_controller.dart';
import 'package:sketching/controllers/focus_controller.dart';
import 'package:sketching/controllers/reset_controller.dart';
import 'package:sketching/controllers/paint_controller.dart';
import 'package:sketching/controllers/redo_controller.dart';
import 'package:sketching/controllers/save_controller.dart';
import 'package:sketching/controllers/save_file_controller.dart';
import 'package:sketching/controllers/selected_area_controller.dart';
import 'package:sketching/controllers/selected_area_cursor_controller.dart';
import 'package:sketching/controllers/selected_paths_controller.dart';
import 'package:sketching/controllers/undo_controller.dart';
import 'package:sketching/controllers/pencil_color_controller.dart';
import 'package:sketching/eventStreams/current_points_event.dart';
import 'package:sketching/eventStreams/translation_event.dart';
import 'package:sketching/eventStreams/zoom_event.dart';
import 'package:sketching/sketch_line.dart';
import 'package:sketching/undo/current_point/current_point_undo_controller.dart';
import 'package:sketching/undo/duplicate/duplicate_undo_controller.dart';
import 'package:sketching/undo/selected_area_drag/selected_area_drag_undo_controller.dart';
import 'controllers/drag_controller.dart';
import 'controllers/draw_controller.dart';
import 'controllers/zoom_controller.dart';
import 'sketching.dart';

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
  CurrentPointUndoController.instance;
  SelectedAreaController.instance;
  SelectedAreaCursorController.instance;
  SelectedPathsController.instance;
  SelectedAreaDragUndoController.instance;
  DuplicateController.instance;
  DuplicateUndoController.instance;
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
      home: Sketching(),
    );
  }
}
