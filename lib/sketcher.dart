
import 'package:flutter/material.dart';
import 'package:sketcher/my_painter.dart';
import 'package:sketcher/sketch_line.dart';

class Sketcher extends StatefulWidget {
  const Sketcher({super.key});

  @override
  State<Sketcher> createState() => _SketcherState();
}

class _SketcherState extends State<Sketcher> {
  SketchLine currentPoints = SketchLine.empty();
  List<SketchLine> previousLines = [];
  bool isErasing = false;

  void onPanStart(DragStartDetails details) {
    setState(() {
      currentPoints = currentPoints
        ..addPoint(details.globalPosition)
        ..isErasing = isErasing;
    });
  }

  void onPanUpdate(DragUpdateDetails details) {
    setState(() {
      currentPoints = SketchLine.from(currentPoints)..addPoint(details.globalPosition);
    });
  }

  void onPanEnd(DragEndDetails details) {
    setState(() {
      previousLines = List.from(previousLines)..add((currentPoints));
      currentPoints = SketchLine.empty();
    });
  }

  void toggleErasing() {
    setState(() {
      isErasing = !isErasing;
    });
  }

  void undo() {
    setState(() {
      previousLines = previousLines..removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      child: GestureDetector(
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            CustomPaint(
              painter: MyPainter(currentPoints: currentPoints, previousLines: previousLines),
            ),
            Row(
              children: [
                TextButton(onPressed: toggleErasing, child: Text(isErasing ? "Draw" : "Erase")),
                TextButton(onPressed: undo, child: Text("Undo")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
