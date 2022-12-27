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
    // var sc = 1.2;
    // canvas.drawCircle(Offset(300, 300), 50, paint..strokeWidth = 5);
    // canvas.scale(sc);
    // canvas.translate(50, 40);
    // canvas.translate(-300 * (sc - 1) / sc, -300 * (sc - 1) / sc);
    // canvas.drawCircle(Offset(300, 300), 50, paint..strokeWidth = 5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
