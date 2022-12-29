import 'dart:ui';

import 'package:sketcher/eventStreams/current_points_event.dart';
import 'package:sketcher/eventStreams/cursor_state_event.dart';
import 'package:sketcher/eventStreams/redo_points_event.dart';

import '../../eventStreams/actions/reset_event.dart';
import '../../eventStreams/translation_event.dart';
import '../../eventStreams/zoom_event.dart';

class ResetController {
  static void instance = ResetController._privateController();

  ResetController._privateController() {
    ResetEvent.instance.stream.listen((_) => _handleEvent());
  }

  void _handleEvent() {
    ZoomEvent.instance.addEvent(1);
    TranslationEvent.instance.addEvent(Offset.zero);
    CursorStateEvent.instance.addEvent(CursorDrawing());
    CurrentPointsEvent.instance.addEvent([]);
    RedoPointsEvent.instance.addEvent([]);
  }
}
