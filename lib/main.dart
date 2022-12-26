import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SketchLine currentPoints = SketchLine.empty();
  List<SketchLine> previousLines = [];
  bool isErasing = false;

  void onPanStart(DragStartDetails details) {
    print('CLICK ON: ${details.globalPosition} and ${details.localPosition}');
    setState(() {
      currentPoints = currentPoints
        ..addPoint(details.globalPosition)
        ..isErasing = isErasing;
    });
  }

  void onPanUpdate(DragUpdateDetails details) {
    print('UPDATE ON: ${details.globalPosition} and ${details.localPosition}');
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
      color: Colors.white,
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

class MyPainter extends CustomPainter {
  final SketchLine currentPoints;
  final List<SketchLine> previousLines;

  MyPainter({required this.currentPoints, required this.previousLines});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    canvas.saveLayer(Rect.largest, Paint());
    for (var line in previousLines) {
      line.drawLine(canvas, paint);
    }
    currentPoints.drawLine(canvas, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SketchLine {
  final List<Offset> points;
  bool isErasing;

  SketchLine({required this.points, required this.isErasing});

  factory SketchLine.from(SketchLine sketchLine) {
    return SketchLine(points: List.from(sketchLine.points), isErasing: sketchLine.isErasing);
  }

  factory SketchLine.empty() {
    return SketchLine(points: [], isErasing: false);
  }

  void addPoint(Offset point) {
    points.add(point);
  }

  void clear() {
    points.clear();
  }

  void drawLine(Canvas canvas, Paint paint) {
    paint.blendMode = isErasing ? BlendMode.clear : BlendMode.srcOver;
    var path = Path();
    path.addPolygon(points, false);
    canvas.drawPath(path, paint);
  }
}
