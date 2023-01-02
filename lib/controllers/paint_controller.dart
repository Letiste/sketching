import 'dart:ui';

import 'package:rxdart/rxdart.dart';
import 'package:sketcher/eventStreams/cursor_state_event.dart';
import 'package:sketcher/eventStreams/paint_state_event.dart';
import 'package:sketcher/eventStreams/pencil_color_event.dart';
import 'package:sketcher/utils/my_paint.dart';
import 'package:sketcher/utils/tuple.dart';
import '../eventStreams/zoom_event.dart';

class PaintController {
  static void instance = PaintController._privateConstructor();

  PaintController._privateConstructor() {
    final pencilColorStream = PencilColorEvent.instance.stream;
    final zoomStream = ZoomEvent.instance.stream;
    final cursorStateStream = CursorStateEvent.instance.stream
        .where((event) => event is CursorDrawing || event is CursorErasing);
    CombineLatestStream.combine3(
      pencilColorStream,
      zoomStream,
      cursorStateStream,
      (pencilColor, zoom, cursorState) => Triple(pencilColor, zoom, cursorState),
    ).listen(_handleEvent);
  }

  void _handleEvent(Triple<Color, double, CursorState> event) {
    var newStrokeWidth = event.third is CursorDrawing ? 5 : 24;
    final color = event.first;
    final strokeWidth = newStrokeWidth / event.second;
    final blendMode = event.third is CursorDrawing ? BlendMode.srcOver : BlendMode.clear;
    final newPaint = MyPaint(color: color, strokeWidth: strokeWidth, blendMode: blendMode);

    PaintStateEvent.instance.addEvent(newPaint);
  }
}
