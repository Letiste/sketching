import 'package:flutter/material.dart';
import 'package:sketcher/controllers/cursor_aspect_controller.dart';
import 'package:sketcher/controllers/focus_controller.dart';
import 'package:sketcher/controllers/reset_controller.dart';
import 'package:sketcher/controllers/paint_controller.dart';
import 'package:sketcher/controllers/redo_controller.dart';
import 'package:sketcher/controllers/undo_controller.dart';
import 'package:sketcher/controllers/pencil_color_controller.dart';
import 'package:window_manager/window_manager.dart';
import 'controllers/drag_controller.dart';
import 'controllers/draw_controller.dart';
import 'controllers/zoom_controller.dart';
import 'sketcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupWindow();
  setupControllers();
  runApp(const MyApp());
}

Future<void> setupWindow() async {
  await windowManager.ensureInitialized();
  await windowManager.waitUntilReadyToShow();
  await windowManager.maximize();
  await windowManager.show();
  await windowManager.focus();
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
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Sketcher(),
    );
  }
}
