import 'package:flutter/material.dart';

import '../eventStreams/pan_state_event.dart';

class PanListener extends StatelessWidget {
  final Widget child;

  const PanListener({super.key, required this.child});

  void onPanStart(DragStartDetails details) {
    PanStateEvent.instance.addEvent(PanStarting(details));
  }

  void onPanUpdate(DragUpdateDetails details) {
    PanStateEvent.instance.addEvent(PanUpdating(details));
  }

  void onPanEnd(DragEndDetails _) {
    PanStateEvent.instance.addEvent(PanEnding());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        behavior: HitTestBehavior.translucent,
        child: child);
  }
}
