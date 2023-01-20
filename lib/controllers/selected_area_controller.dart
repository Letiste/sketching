import 'package:rxdart/rxdart.dart';
import 'package:sketcher/eventStreams/selected_area_event.dart';
import 'package:sketcher/selected_area.dart';

import '../eventStreams/cursor_state_event.dart';
import '../eventStreams/pan_state_event.dart';
import '../utils/tuple.dart';

class SelectedAreaController {
  late SelectedArea _selectedArea;

  static void instance = SelectedAreaController._privateController();

  SelectedAreaController._privateController() {
    _setupStreams();
    final cursorStateStream = CursorStateEvent.instance.stream;
    final panStateStream = PanStateEvent.instance.stream;
    CombineLatestStream.combine2(
      cursorStateStream,
      panStateStream,
      (cursorState, panState) => Pair(cursorState, panState),
    )
        .where((event) => event.first is CursorSelecting)
        .map((event) => event.second)
        .listen(_handleEvent);
  }

  void _handleEvent(PanState panState) {
    if (panState is PanStarting) {
      SelectedAreaEvent.instance.addEvent(SelectedArea.empty());
    }
    if (panState is PanUpdating) {
      final mousePosition = panState.details.localPosition;
      SelectedArea newSelectedArea;
      if (_selectedArea.isEmpty) {
        newSelectedArea = SelectedArea(
          firstCorner: mousePosition,
          secondCorner: mousePosition,
        );
      } else {
        newSelectedArea = SelectedArea(
          firstCorner: _selectedArea.firstCorner,
          secondCorner: mousePosition,
        );
      }
      SelectedAreaEvent.instance.addEvent(newSelectedArea);
    }
  }

  void _setupStreams() {
    SelectedAreaEvent.instance.stream.listen((event) => _selectedArea = event);
  }
}
