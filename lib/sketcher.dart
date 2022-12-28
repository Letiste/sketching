import 'dart:math';

import 'package:flutter/gestures.dart';
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
  bool isDragging = false;
  Color color = Colors.red;
  double strokeWidth = 5;
  Offset translate = Offset.zero;
  double zoom = 100;
  double get scale => zoom / 100;

  void onPanStart(DragStartDetails details) {
    print('CURSOR CANVAS POSITION: ${(details.globalPosition - translate) / scale}');
    print('CURSOR WINDOW POSITION: ${(details.globalPosition)}');
    if (!isDragging) {
      setState(() {
        currentPoints = SketchLine(
          points: [(details.globalPosition - translate) / scale],
          color: color,
          scale: scale,
          isErasing: isErasing,
        );
        redoLines = [];
      });
    }
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (!isDragging) {
      setState(() {
        currentPoints = SketchLine.from(currentPoints)..addPoint((details.globalPosition - translate) / scale);
      });
    } else {
      setState(() {
        translate += details.delta;
      });
    }
  }

  void onPanEnd(DragEndDetails details) {
    if (!isDragging) {
      setState(() {
        previousLines = List.from(previousLines)..add(currentPoints);
        currentPoints = SketchLine.empty();
      });
    }
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

  void focus() {
    setState(() {
      zoom = 100;
      translate = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerSignal: (pointerSignal) {
          if (pointerSignal is PointerScrollEvent) {
            setState(() {
              var cursorWindowPosition = pointerSignal.localPosition;
              var cursorCanvasPosition = (cursorWindowPosition - translate) / scale;
              zoom += pointerSignal.scrollDelta.dy;
              zoom = max(zoom, 1);
              translate = cursorWindowPosition - cursorCanvasPosition * scale;
            });
          }
        },
        child: GestureDetector(
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanEnd: onPanEnd,
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              CustomPaint(
                painter: MyPainter(
                  lines: [...previousLines, currentPoints],
                  translate: translate,
                  scale: scale,
                ),
              ),
              Row(
                children: [
                  TextButton(onPressed: toggleErasing, child: Text(isErasing ? "Draw" : "Erase")),
                  TextButton(onPressed: undo, child: Text("Undo")),
                  TextButton(onPressed: redo, child: Text("Redo")),
                  TextButton(onPressed: reset, child: Text("Reset")),
                  TextButton(onPressed: () => updateColor(Colors.blue), child: Text("Blue")),
                  TextButton(onPressed: () => updateColor(Colors.red), child: Text("Red")),
                  TextButton(
                    onPressed: () => setState(() => isDragging = !isDragging),
                    child: Text(isDragging ? "Draw" : "Drag"),
                  ),
                  TextButton(onPressed: focus, child: Text("Focus")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
