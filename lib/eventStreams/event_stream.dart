import 'dart:async';

import 'package:rxdart/rxdart.dart';

class EventStream<T> {
  late final StreamController<T> _eventController;

  EventStream([T? initialValue]) {
    if (initialValue != null) {
      _eventController = BehaviorSubject.seeded(initialValue);
    } else {
      _eventController = BehaviorSubject();
    }
  }

  void addEvent(T event) {
    _eventController.add(event);
  }

  Stream<T> get stream => _eventController.stream;
}
