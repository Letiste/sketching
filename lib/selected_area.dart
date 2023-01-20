import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import 'sketch_line.dart';

class SelectedArea {
  final Offset firstCorner;
  final Offset secondCorner;
  final bool isEmpty;
  Path? path;
  Path? _area;
  final Paint _paint = Paint();

  SelectedArea({required this.firstCorner, required this.secondCorner, this.isEmpty = false});

  factory SelectedArea.empty() {
    return SelectedArea(firstCorner: Offset.zero, secondCorner: Offset.zero, isEmpty: true);
  }

  factory SelectedArea.from(SelectedArea selectedArea) {
    return SelectedArea(
      firstCorner: selectedArea.firstCorner,
      secondCorner: selectedArea.secondCorner,
    );
  }

  bool contains(Offset point) {
    if (_area == null) return false;
    return _area!.contains(point);
  }

  void drawArea(Canvas canvas) {
    if (isEmpty) return;
    if (path != null) {
      return canvas.drawPath(path!, _paint);
    }
    _area = Path()..addRect(Rect.fromPoints(firstCorner, secondCorner));
    _paint
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    path = dashPath(_area!, dashArray: CircularIntervalList([5, 5]));
    canvas.drawPath(path!, _paint);
  }

  List<int> getSelectedPathsIndex(List<SketchLine> sketchLines) {
    if (path == null) return [];
    List<int> selectedPathsIndex = [];
    for (var i = 0; i < sketchLines.length; i++) {
      final sketchLine = sketchLines[i];

      if (sketchLine.path == null) continue;

      final pathCombine = Path.combine(PathOperation.intersect, _area!, sketchLine.path!);
      if (!pathCombine.getBounds().isEmpty) {
        selectedPathsIndex.add(i);
      }
    }
    return selectedPathsIndex;
  }
}
