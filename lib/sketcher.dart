import 'package:flutter/material.dart';

import 'my_painter.dart';
import 'sketch_line.dart';

class Sketcher extends StatefulWidget {
  const Sketcher({super.key});

  @override
  State<Sketcher> createState() => _SketcherState();
}

class _SketcherState extends State<Sketcher> {
  SketchLine currentPoints = SketchLine.empty();
  List<SketchLine> previousLines = [];
  List<SketchLine> redoLines = [];
  bool isErasing = false;
  Color color = Colors.red;

  void onPanStart(DragStartDetails details) {
    setState(() {
      currentPoints = currentPoints
        ..addPoint(details.globalPosition)
        ..color = color
        ..isErasing = isErasing;
      redoLines = [];
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
    if (previousLines.isNotEmpty) {
      setState(() {
        redoLines = redoLines..add(previousLines.last);
        previousLines = previousLines..removeLast();
      });
    }
  }

  void redo() {
    if (redoLines.isNotEmpty) {
      setState(() {
        previousLines = previousLines..add(redoLines.last);
        redoLines = redoLines..removeLast();
      });
    }
  }

  void updateColor(Color newColor) {
    setState(() {
      isErasing = false;
      color = newColor;
    });
  }

  void reset() {
    setState(() {
      previousLines = previousLines..clear();
      redoLines = redoLines..clear();
      isErasing = false;
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
                TextButton(onPressed: redo, child: Text("Redo")),
                TextButton(onPressed: reset, child: Text("Reset")),
                TextButton(onPressed: () => updateColor(Colors.blue), child: Text("Blue")),
                TextButton(onPressed: () => updateColor(Colors.red), child: Text("Red")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
