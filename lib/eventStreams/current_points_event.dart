import '../sketch_line.dart';
import 'event_stream.dart';

class CurrentPointsEvent {
  static final EventStream<List<SketchLine>> instance = EventStream([]);
}
