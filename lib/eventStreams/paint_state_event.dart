import 'package:sketcher/utils/my_paint.dart';

import 'event_stream.dart';

class PaintStateEvent {
  static final EventStream<MyPaint> instance = EventStream();
}
