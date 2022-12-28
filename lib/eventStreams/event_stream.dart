import 'dart:async';

class EventStream<T> {
  final StreamController<T> _eventController = StreamController.broadcast();

  void addEvent(T event) {
    _eventController.add(event);
  }

  Stream<T> get stream => _eventController.stream;
}
