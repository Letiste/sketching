import 'package:sketcher/sketch_line.dart';
import 'event_stream.dart';

class RedoPointsEvent {
  static final EventStream<List<SketchLine>> instance = EventStream([]);
}
