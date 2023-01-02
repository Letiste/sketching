import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';
import 'package:sketcher/eventStreams/cursor_aspect_event.dart';
import 'package:sketcher/eventStreams/mouse_on_screen_event.dart';
import 'package:sketcher/eventStreams/mouse_position_event.dart';
import 'package:sketcher/eventStreams/current_points_event.dart';
import 'package:sketcher/shortcuts_mapping.dart';
import 'eventStreams/translation_event.dart';
import 'eventStreams/zoom_event.dart';
import 'my_painter.dart';
import 'sketch_line.dart';
import 'utils/tuple.dart';
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

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onExit: (event) => MouseOnScreenEvent.instance.addEvent(false),
      onEnter: (event) => MouseOnScreenEvent.instance.addEvent(true),
      child: CallbackShortcuts(
        bindings: ShortcutsMapping.shortcutsMapping,
        child: Focus(
          autofocus: true,
          child: ScrollListener(
            child: PanListener(
              child: Container(
                color: Colors.grey.shade900,
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
                        return CustomPaint(
                          painter: MyPainter(
                            lines: currentPoint,
                            translate: translation,
                            scale: zoom,
                          ),
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: CombineLatestStream.combine2(
                        MousePositionEvent.instance.stream,
                        CursorAspectEvent.instance.stream,
                        (mousePosition, cursorAspect) => Pair(mousePosition, cursorAspect),
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        return Positioned(
                          left: snapshot.data!.first.dx,
                          top: snapshot.data!.first.dy,
                          child: snapshot.data!.second,
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
