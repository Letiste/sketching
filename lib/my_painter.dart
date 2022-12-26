import 'package:flutter/material.dart';
import 'package:sketcher/sketch_line.dart';

class MyPainter extends CustomPainter {
  final SketchLine currentPoints;
  final List<SketchLine> previousLines;

  MyPainter({required this.currentPoints, required this.previousLines});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    canvas.saveLayer(Rect.largest, Paint());
    for (var line in previousLines) {
      line.drawLine(canvas, paint);
    }
    currentPoints.drawLine(canvas, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
