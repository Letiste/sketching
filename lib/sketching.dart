import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';
import 'package:sketching/eventStreams/cursor_aspect_event.dart';
import 'package:sketching/eventStreams/mouse_on_screen_event.dart';
import 'package:sketching/eventStreams/mouse_position_event.dart';
import 'package:sketching/eventStreams/current_points_event.dart';
import 'package:sketching/eventStreams/selected_area_event.dart';
import 'package:sketching/selected_area.dart';
import 'package:sketching/shortcuts_mapping.dart';
import 'package:sketching/widgets/context_menu.dart';
import 'eventStreams/translation_event.dart';
import 'eventStreams/zoom_event.dart';
import 'my_painter.dart';
import 'sketch_line.dart';
import 'utils/tuple.dart';
import 'widgets/pan_listener.dart';
import 'widgets/scroll_listener.dart';

class Sketching extends StatelessWidget {
  final dynamic stream = CombineLatestStream.combine4(
    ZoomEvent.instance.stream,
    TranslationEvent.instance.stream,
    CurrentPointsEvent.instance.stream,
    SelectedAreaEvent.instance.stream,
    (zoom, translation, currentPoints, selectedArea) =>
        [zoom, translation, currentPoints, selectedArea],
  );

  Sketching({super.key});

  @override
  Widget build(BuildContext context) {
    return ContextMenu(
      child: MouseRegion(
        cursor: SystemMouseCursors.none,
        onExit: (event) => MouseOnScreenEvent.instance.addEvent(false),
        onEnter: (event) {
          MouseOnScreenEvent.instance.addEvent(true);
          MousePositionEvent.instance.addEvent(event.localPosition);
        },
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
                      RepaintBoundary(
                        child: StreamBuilder<List>(
                          stream: stream,
                          builder: (context, snapshot) {
                            var zoom = 1.0;
                            var translation = Offset.zero;
                            List<SketchLine> currentPoint = [];
                            SelectedArea selectedArea = SelectedArea.empty();
                            if (snapshot.hasData) {
                              zoom = snapshot.data!.first as double;
                              translation = snapshot.data![1] as Offset;
                              currentPoint = snapshot.data![2] as List<SketchLine>;
                              selectedArea = snapshot.data![3];
                            }
                            return CustomPaint(
                              painter: MyPainter(
                                lines: currentPoint,
                                selectedArea: selectedArea,
                                translate: translation,
                                scale: zoom,
                              ),
                            );
                          },
                        ),
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
      ),
    );
  }
}
