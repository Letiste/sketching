import 'dart:ui';

import 'package:rxdart/rxdart.dart';
import '../eventStreams/cursor_state_event.dart';
import '../eventStreams/translation_event.dart';
import '../utils/tuple.dart';

import '../eventStreams/pan_state_event.dart';

class DragController {
  late Offset _currentTranslation;

  static void instance = DragController._privateController();

  DragController._privateController() {
    _setupStreams();
    final cursorStateStream = CursorStateEvent.instance.stream;
    final panStateStream = PanStateEvent.instance.stream;
    CombineLatestStream.combine2(
      cursorStateStream,
      panStateStream,
      (cursorState, panState) => Pair(cursorState, panState),
    )
        .where((event) => event.first is CursorDragging)
        .map((event) => event.second)
        .listen(_handleEvent);
  }

  void _handleEvent(PanState panState) {
    if (panState is PanUpdating) {
      final newTranslation = _currentTranslation + panState.details.delta;
      TranslationEvent.instance.addEvent(newTranslation);
    }
  }

  void _setupStreams() {
    TranslationEvent.instance.stream.listen((event) => _currentTranslation = event);
  }
}
