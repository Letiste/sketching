import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class SelectedArea {
  final Offset firstCorner;
  final Offset secondCorner;
  final bool isEmpty;

  const SelectedArea({required this.firstCorner, required this.secondCorner, this.isEmpty = false});

  factory SelectedArea.empty() {
    return SelectedArea(firstCorner: Offset.zero, secondCorner: Offset.zero, isEmpty: true);
  }

  void drawArea(Canvas canvas) {
    if (isEmpty) return;
    final path1 = Path();
    path1.addRect(Rect.fromPoints(firstCorner, secondCorner));
    var selectPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(dashPath(path1, dashArray: CircularIntervalList([5, 5])), selectPaint);
  }
}
