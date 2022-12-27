import 'package:flutter/material.dart';

class SketchLine {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;
  final bool isErasing;

  SketchLine({required this.points, required this.color, required this.strokeWidth, required this.isErasing});

  factory SketchLine.from(SketchLine sketchLine) {
    return SketchLine(
      points: List.from(sketchLine.points),
      color: sketchLine.color,
      strokeWidth: sketchLine.strokeWidth,
      isErasing: sketchLine.isErasing,
    );
  }

  factory SketchLine.empty() {
    return SketchLine(points: [], color: Colors.red, strokeWidth: 5, isErasing: false);
  }

  void addPoint(Offset point) {
    points.add(point);
  }

  void clear() {
    points.clear();
  }

  void drawLine(Canvas canvas, Paint paint) {
    paint
      ..blendMode = isErasing ? BlendMode.clear : BlendMode.srcOver
      ..color = color
      ..strokeWidth = strokeWidth;
    var path = Path();
    path.addPolygon(points, false);
    canvas.drawPath(path, paint);
  }
}
