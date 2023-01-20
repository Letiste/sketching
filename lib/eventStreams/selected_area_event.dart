import 'package:sketcher/selected_area.dart';

import 'event_stream.dart';

class SelectedAreaEvent {
  static final EventStream<SelectedArea> instance = EventStream(SelectedArea.empty());
}
