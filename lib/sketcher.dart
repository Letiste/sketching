import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';

import 'eventStreams/translate_event.dart';
import 'eventStreams/zoom_event.dart';
import 'my_painter.dart';
import 'sketch_line.dart';
import 'widgets/scroll_listener.dart';

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
  double zoom = 1;
  double get scale => zoom / 1;
  dynamic stream = CombineLatestStream.combine2(
      ZoomEvent.instance.stream, TranslateEvent.instance.stream, (zoom, translate) => [zoom, translate]);

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
      zoom = 1;
      translate = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      child: ScrollListener(
        child: GestureDetector(
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanEnd: onPanEnd,
          behavior: HitTestBehavior.translucent,
          child: Stack(
            children: [
              StreamBuilder(
                  stream: CombineLatestStream.combine2(ZoomEvent.instance.stream, TranslateEvent.instance.stream,
                      (zoom, translate) => [zoom, translate]),
                  builder: (context, snapshot) {
                    final zoom = snapshot.data?.first as double?;
                    final translate = snapshot.data?.last as Offset?;
                    return CustomPaint(
                      painter: MyPainter(
                        lines: [...previousLines, currentPoints],
                        translate: translate ?? Offset.zero,
                        scale: zoom ?? 1,
                      ),
                    );
                  }),
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
