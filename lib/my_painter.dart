import 'package:flutter/material.dart';

import 'selected_area.dart';
import 'sketch_line.dart';

class MyPainter extends CustomPainter {
  final List<SketchLine> lines;
  final SelectedArea selectedArea;
  final Offset translate;
  final double scale;

  MyPainter({
    required this.lines,
    required this.selectedArea,
    required this.translate,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(translate.dx, translate.dy);
    canvas.scale(scale);
    canvas.saveLayer(Rect.largest, Paint());

    for (var line in lines) {
      line.drawLine(canvas);
    }
    selectedArea.drawArea(canvas);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
