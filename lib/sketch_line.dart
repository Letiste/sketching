import 'package:flutter/material.dart';

class SketchLine {
  final List<Offset> points;
  bool isErasing;
  Color color;

  SketchLine({required this.points, required this.color, required this.isErasing});

  factory SketchLine.from(SketchLine sketchLine) {
    return SketchLine(points: List.from(sketchLine.points), color: sketchLine.color, isErasing: sketchLine.isErasing);
  }

  factory SketchLine.empty() {
    return SketchLine(points: [], color: Colors.red, isErasing: false);
  }

  void addPoint(Offset point) {
    points.add(point);
  }

  void clear() {
    points.clear();
  }

  void drawLine(Canvas canvas, Paint paint) {
    paint.blendMode = isErasing ? BlendMode.clear : BlendMode.srcOver;
    paint.color = color;
    var path = Path();
    path.addPolygon(points, false);
    canvas.drawPath(path, paint);
  }
}
