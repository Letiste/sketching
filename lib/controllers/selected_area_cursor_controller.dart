import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sketching/eventStreams/cursor_state_event.dart';
import 'package:sketching/eventStreams/mouse_button_state_event.dart';
import 'package:sketching/eventStreams/mouse_position_event.dart';
import 'package:sketching/eventStreams/selected_area_event.dart';
import 'package:sketching/selected_area.dart';
import 'package:sketching/utils/tuple.dart';

import '../eventStreams/translation_event.dart';
import '../eventStreams/zoom_event.dart';

class SelectedAreaCursorController {
  late Offset _currentTranslation;
  late double _currentZoom;

  static void instance = SelectedAreaCursorController._privateController();

  SelectedAreaCursorController._privateController() {
    _setupStreams();
    final selectedAreaStream = SelectedAreaEvent.instance.stream;
    final mousePositionStream = MousePositionEvent.instance.stream.map(
      (mousePosition) => _getPointPosition(mousePosition),
    );
    final mouseButtonStateStream = MouseButtonStateEvent.instance.stream;
    CombineLatestStream.combine3(
      selectedAreaStream,
      mousePositionStream,
      mouseButtonStateStream,
      (selectedArea, mousePosition, mouseButtonState) =>
          Triple(selectedArea, mousePosition, mouseButtonState),
    )
        .where((event) => !event.first.isEmpty && event.third is MouseButtonUp)
        .map((event) => Pair(event.first, event.second))
        .distinct(_equalsCursorEvent)
        .listen(_handleEvent);
  }

  void _handleEvent(Pair<SelectedArea, Offset> event) {
    final selectedArea = event.first;
    final mousePosition = event.second;

    if (selectedArea.contains(mousePosition)) {
      CursorStateEvent.instance.addEvent(CursorInSelectingArea());
    } else {
      CursorStateEvent.instance.addEvent(CursorSelecting());
    }
  }

  bool _equalsCursorEvent(Pair<SelectedArea, Offset> previous, Pair<SelectedArea, Offset> next) {
    final previousSelectedArea = previous.first;
    final previousMousePosition = previous.second;
    final nextSelectedArea = next.first;
    final nextMousePosition = next.second;
    return previousSelectedArea.contains(previousMousePosition) ==
        nextSelectedArea.contains(nextMousePosition);
  }

  Offset _getPointPosition(Offset cursorWindowPosition) {
    return (cursorWindowPosition - _currentTranslation) / _currentZoom;
  }

  void _setupStreams() {
    ZoomEvent.instance.stream.listen((event) => _currentZoom = event);
    TranslationEvent.instance.stream.listen((event) => _currentTranslation = event);
  }
}
