import 'package:flutter/gestures.dart';
import 'package:sketcher/eventStreams/scroll_event.dart';
import 'package:sketcher/eventStreams/translate_event.dart';
import 'package:sketcher/eventStreams/zoom_event.dart';

class ZoomController {
  static double _currentZoom = 1;
  static Offset _currentTranslation = Offset.zero;

  static void instance = ZoomController._privateConstructor();

  ZoomController._privateConstructor() {
    ZoomEvent.instance.stream.listen((event) => _currentZoom = event);
    TranslateEvent.instance.stream.listen((event) => _currentTranslation = event);
    ScrollEvent.instance.stream.listen(_handleEvent);
  }

  double _calculateNewZoom(PointerScrollEvent pointer) {
    final update = pointer.scrollDelta.dy > 0 ? 1.1 : 0.9;
    return _currentZoom * update;
  }

  Offset _calculateNewTranslation(PointerScrollEvent pointer) {
    final newZoom = _calculateNewZoom(pointer);
    final cursorWindowPosition = pointer.localPosition;
    final cursorCanvasPosition = (cursorWindowPosition - _currentTranslation) / _currentZoom;
    return cursorWindowPosition - cursorCanvasPosition * newZoom;
  }

  void _handleEvent(PointerScrollEvent pointer) {
    final newZoom = _calculateNewZoom(pointer);
    final newTranslation = _calculateNewTranslation(pointer);
    ZoomEvent.instance.addEvent(newZoom);
    TranslateEvent.instance.addEvent(newTranslation);
  }
}
