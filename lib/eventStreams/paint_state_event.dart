import 'package:sketching/utils/my_paint.dart';

import 'event_stream.dart';

class PaintStateEvent {
  static final EventStream<MyPaint> instance = EventStream();
}
