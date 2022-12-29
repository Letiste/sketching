import 'event_stream.dart';

abstract class MouseButtonState {}

class MouseButtonDown extends MouseButtonState {}
class MouseButtonUp extends MouseButtonState {}

class MouseButtonStateEvent {
  static final EventStream<MouseButtonState> instance = EventStream(MouseButtonUp());
}
