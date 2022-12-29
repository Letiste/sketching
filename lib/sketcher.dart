import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';
import 'package:sketcher/eventStreams/actions/focus_event.dart';
import 'package:sketcher/eventStreams/actions/reset_event.dart';
import 'package:sketcher/eventStreams/current_points_event.dart';
import 'eventStreams/actions/redo_event.dart';
import 'eventStreams/actions/undo_event.dart';
import 'eventStreams/cursor_state_event.dart';
import 'eventStreams/pencil_color_event.dart';
import 'eventStreams/translation_event.dart';
import 'eventStreams/zoom_event.dart';
import 'my_painter.dart';
import 'sketch_line.dart';
import 'widgets/pan_listener.dart';
import 'widgets/scroll_listener.dart';

class Sketcher extends StatelessWidget {

  final dynamic stream = CombineLatestStream.combine3(
    ZoomEvent.instance.stream,
    TranslationEvent.instance.stream,
    CurrentPointsEvent.instance.stream,
    (zoom, translation, currentPoints) => [zoom, translation, currentPoints],
  );

  Sketcher({super.key});

  void toggleDrawing() {
    CursorStateEvent.instance.addEvent(CursorDrawing());
  }

  void toggleErasing() {
    CursorStateEvent.instance.addEvent(CursorErasing());
  }

  void toggleDragging() {
    CursorStateEvent.instance.addEvent(CursorDragging());
  }

  void undo() {
    UndoEvent.instance.addEvent(true);
  }

  void redo() {
    RedoEvent.instance.addEvent(true);
  }

  void updateColor(Color newColor) {
    PencilColorEvent.instance.addEvent(newColor);
  }

  void reset() {
    ResetEvent.instance.addEvent(true);
  }

  void focus() {
    FocusEvent.instance.addEvent(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      child: ScrollListener(
        child: PanListener(
          child: Stack(
            children: [
              StreamBuilder<List>(
                  stream: stream,
                  builder: (context, snapshot) {
                    var zoom = 1.0;
                    var translation = Offset.zero;
                    List<SketchLine> currentPoint = [];
                    if (snapshot.hasData) {
                      zoom = snapshot.data!.first as double;
                      translation = snapshot.data![1] as Offset;
                      currentPoint = snapshot.data![2] as List<SketchLine>;
                    }
                    print('TRANSLATION: ${currentPoint.length}');
                    return CustomPaint(
                      painter: MyPainter(
                        lines: currentPoint,
                        translate: translation,
                        scale: zoom,
                      ),
                    );
                  }),
              Row(
                children: [
                  TextButton(onPressed: toggleDrawing, child: Text("Draw")),
                  TextButton(onPressed: toggleErasing, child: Text("Erase")),
                  TextButton(onPressed: toggleDragging, child: Text("Drag")),
                  TextButton(onPressed: undo, child: Text("Undo")),
                  TextButton(onPressed: redo, child: Text("Redo")),
                  TextButton(onPressed: reset, child: Text("Reset")),
                  TextButton(onPressed: () => updateColor(Colors.blue), child: Text("Blue")),
                  TextButton(onPressed: () => updateColor(Colors.red), child: Text("Red")),
                  TextButton(onPressed: focus, child: Text("Focus")),
                  // StreamBuilder(
                  //     stream: CurrentPointsEvent.instance.stream,
                  //     builder: (context, snapshot) {
                  //       print("PANSTATE");
                  //       if (snapshot.hasData) {
                  //         return Text('${snapshot.data!.last.points.length}');
                  //       }
                  //       return Text('toto');
                  //     }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
