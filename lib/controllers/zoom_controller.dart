import 'package:flutter/gestures.dart';
import '../eventStreams/scroll_event.dart';
import '../eventStreams/translation_event.dart';
import '../eventStreams/zoom_event.dart';

class ZoomController {
  late double _currentZoom;
  late Offset _currentTranslation;

  static void instance = ZoomController._privateConstructor();

  ZoomController._privateConstructor() {
    _setupStreams();
    ScrollEvent.instance.stream.listen(_handleEvent);
  }

  void _handleEvent(PointerScrollEvent pointer) {
    final newZoom = _calculateNewZoom(pointer);
    final newTranslation = _calculateNewTranslation(pointer);
    ZoomEvent.instance.addEvent(newZoom);
    TranslationEvent.instance.addEvent(newTranslation);
  }

  double _calculateNewZoom(PointerScrollEvent pointer) {
    final update = pointer.scrollDelta.dy < 0 ? 1.1 : 0.9;
    return _currentZoom * update;
  }

  Offset _calculateNewTranslation(PointerScrollEvent pointer) {
    final newZoom = _calculateNewZoom(pointer);
    final cursorWindowPosition = pointer.localPosition;
    final cursorCanvasPosition = (cursorWindowPosition - _currentTranslation) / _currentZoom;
    return cursorWindowPosition - cursorCanvasPosition * newZoom;
  }

  void _setupStreams() {
    ZoomEvent.instance.stream.listen((event) => _currentZoom = event);
    TranslationEvent.instance.stream.listen((event) => _currentTranslation = event);
  }
}
