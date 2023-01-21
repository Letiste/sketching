import 'package:flutter/gestures.dart';
import 'package:sketching/eventStreams/mouse_position_event.dart';
import 'package:sketching/eventStreams/zoom_change_event.dart';
import '../eventStreams/translation_event.dart';
import '../eventStreams/zoom_event.dart';

class ZoomController {
  late double _currentZoom;
  late Offset _currentTranslation;
  late Offset _currentMousePosition;

  static void instance = ZoomController._privateConstructor();

  ZoomController._privateConstructor() {
    _setupStreams();
    ZoomChangeEvent.instance.stream.listen(_handleEvent);
  }

  void _handleEvent(ZoomChange zoomChange) {
    final newZoom = _calculateNewZoom(zoomChange);
    final newTranslation = _calculateNewTranslation(newZoom);
    ZoomEvent.instance.addEvent(newZoom);
    TranslationEvent.instance.addEvent(newTranslation);
  }

  double _calculateNewZoom(ZoomChange zoomChange) {
    final update = zoomChange is ZoomIncrease ? 1.1 : 0.9;
    return _currentZoom * update;
  }

  Offset _calculateNewTranslation(double newZoom) {
    final cursorCanvasPosition = (_currentMousePosition - _currentTranslation) / _currentZoom;
    return _currentMousePosition - cursorCanvasPosition * newZoom;
  }

  void _setupStreams() {
    ZoomEvent.instance.stream.listen((event) => _currentZoom = event);
    TranslationEvent.instance.stream.listen((event) => _currentTranslation = event);
    MousePositionEvent.instance.stream.listen((event) => _currentMousePosition = event);
  }
}
