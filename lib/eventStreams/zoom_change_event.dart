import 'event_stream.dart';

abstract class ZoomChange {}

class ZoomIncrease extends ZoomChange {}

class ZoomDecrease extends ZoomChange {}

class ZoomChangeEvent {
  static final EventStream<ZoomChange> instance = EventStream();
}
