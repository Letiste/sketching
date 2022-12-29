import 'package:sketcher/eventStreams/cursor_state_event.dart';
import 'package:sketcher/eventStreams/pencil_color_event.dart';

class PencilColorController {
  static void instance = PencilColorController._privateController();

  PencilColorController._privateController() {
    PencilColorEvent.instance.stream.listen((_) => _handleEvent());
  }

  void _handleEvent() {
    CursorStateEvent.instance.addEvent(CursorDrawing());
  }
}
