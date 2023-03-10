import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sketching/utils/my_paint.dart';

class SketchLine {
  List<Offset> points;
  final double scale;
  final MyPaint paint;
  Path? path;

  SketchLine({required this.points, required this.scale, required this.paint});

  factory SketchLine.from(SketchLine sketchLine) {
    return SketchLine(
      points: List.from(sketchLine.points),
      scale: sketchLine.scale,
      paint: MyPaint.from(sketchLine.paint),
    );
  }

  factory SketchLine.fromJson(Map<String, dynamic> json) {
    return SketchLine(
      points: List<Offset>.from((json['points'])
          .map(
            (point) => Offset(point[0], point[1]),
          )
          .toList()),
      scale: json['scale'],
      paint: MyPaint.fromJson(json['paint']),
    );
  }

  Map<String, dynamic> toJson() => {
        'points': points.map((point) => [point.dx, point.dy]).toList(),
        'scale': scale,
        'paint': paint
      };

  void shift(Offset drag) {
    if (path == null) return;
    path = path!.shift(drag);
  }

  void addPoint(Offset point) {
    points.add(point);
    path = null;
    if (points.length >= 3) {
      _filterPoint();
    }
  }

  void drawLine(Canvas canvas) {
    _computeSmoothLine();
    if (path != null) {
      canvas.drawPath(path!, paint);
    }
  }

  void _filterPoint() {
    final l = points.length;
    final p1 = points[l - 2];
    final p2 = points[l - 3];
    final p3 = points[l - 1];
    final angle = _getAngle(p1, p2, p3) * scale;
    final distance = _getDistance(p1, p2) * scale;
    if (!(angle < pi / 2 || distance > 10)) {
      points.removeAt(l - 2);
    }
  }

  void _computeSmoothLine() {
    if (points.length < 3) {
      return;
    }
    if (path != null) {
      return;
    }
    const smoothFactor = 0.2;
    path = Path();
    path!.moveTo(points[0].dx, points[0].dy);
    var p1 = points[1] - (points[2] - points[0]) * smoothFactor;
    path!.quadraticBezierTo(p1.dx, p1.dy, points[1].dx, points[1].dy);
    for (var i = 1; i < points.length - 2; i++) {
      p1 = points[i] + (points[i + 1] - points[i - 1]) * smoothFactor;
      var p2 = points[i + 1] - (points[i + 2] - points[i]) * smoothFactor;
      path!.cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, points[i + 1].dx, points[i + 1].dy);
    }
    p1 = points[points.length - 2] +
        (points[points.length - 1] - points[points.length - 3]) * smoothFactor;
    path!.quadraticBezierTo(p1.dx, p1.dy, points.last.dx, points.last.dy);
  }

  double _getAngle(Offset p1, Offset p2, Offset p3) {
    final d12 = (p1 - p2).distance;
    final d13 = (p1 - p3).distance;
    final d23 = (p2 - p3).distance;
    return acos((d12 * d12 + d13 * d13 - d23 * d23) / (2 * d12 * d13));
  }

  double _getDistance(Offset p1, Offset p2) {
    return (p1 - p2).distance;
  }
}
