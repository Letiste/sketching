import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import 'sketch_line.dart';

class SelectedArea {
  final Offset firstCorner;
  final Offset secondCorner;
  final bool isEmpty;
  final double scale;
  Path? path;
  Path? _area;
  final Paint _paint = Paint();
  List<int>? selectedPathsIndex;

  SelectedArea(
      {required this.firstCorner,
      required this.secondCorner,
      required this.scale,
      this.isEmpty = false});

  factory SelectedArea.empty() {
    return SelectedArea(
        firstCorner: Offset.zero, secondCorner: Offset.zero, scale: 1, isEmpty: true);
  }

  factory SelectedArea.from(SelectedArea selectedArea) {
    return SelectedArea(
      firstCorner: selectedArea.firstCorner,
      secondCorner: selectedArea.secondCorner,
      scale: selectedArea.scale,
    );
  }

  bool contains(Offset point) {
    if (_area == null) return false;
    return _area!.contains(point);
  }

  void shift(Offset drag, List<SketchLine> sketchLines) {
    if (path == null || _area == null || selectedPathsIndex == null) return;
    for (final selectedPath in selectedPathsIndex!) {
      final sketchLine = sketchLines[selectedPath];
      final newPoints = sketchLine.points.map((point) => point + drag).toList();
      sketchLines[selectedPath] = SketchLine.from(sketchLine)..points = newPoints;
    }
    path = path!.shift(drag);
    _area = _area!.shift(drag);
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
      ..strokeWidth = 2 / scale;
    final dashInterval = 5 / scale;
    path = dashPath(_area!, dashArray: CircularIntervalList([dashInterval, dashInterval]));
    canvas.drawPath(path!, _paint);
  }

  List<int> getSelectedPathsIndex(List<SketchLine> sketchLines) {
    if (path == null) return [];
    if (selectedPathsIndex != null) return selectedPathsIndex!;
    selectedPathsIndex = [];
    for (var i = 0; i < sketchLines.length; i++) {
      final sketchLine = sketchLines[i];

      if (sketchLine.path == null) continue;

      final pathCombine = Path.combine(PathOperation.intersect, _area!, sketchLine.path!);
      if (!pathCombine.getBounds().isEmpty) {
        selectedPathsIndex!.add(i);
      }
    }
    return selectedPathsIndex!;
  }
}
