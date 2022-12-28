import 'package:flutter/material.dart';

import 'sketch_line.dart';

class MyPainter extends CustomPainter {
  final List<SketchLine> lines;
  final Offset translate;
  final double scale;

  MyPainter({
    required this.lines,
    required this.translate,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeCap = StrokeCap.round;
    canvas.translate(translate.dx, translate.dy);
    canvas.scale(scale);
    canvas.saveLayer(Rect.largest, Paint());
    for (var line in lines) {
      line.drawLine(canvas, paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
