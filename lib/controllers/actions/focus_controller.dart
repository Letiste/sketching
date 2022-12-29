import 'dart:ui';

import '../../eventStreams/actions/focus_event.dart';
import '../../eventStreams/translation_event.dart';
import '../../eventStreams/zoom_event.dart';

class FocusController {

  static void instance = FocusController._privateController();

  FocusController._privateController() {
    FocusEvent.instance.stream.listen((_) => _handleEvent());
  }

  void _handleEvent() {
    ZoomEvent.instance.addEvent(1);
    TranslationEvent.instance.addEvent(Offset.zero);
  }
}
