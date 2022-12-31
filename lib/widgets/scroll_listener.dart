import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sketcher/eventStreams/mouse_position_event.dart';
import 'package:sketcher/eventStreams/zoom_change_event.dart';

import '../eventStreams/mouse_button_state_event.dart';

class ScrollListener extends StatelessWidget {
  final Widget child;

  const ScrollListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerHover: (event) => MousePositionEvent.instance.addEvent(event.localPosition),
      onPointerMove: (event) => MousePositionEvent.instance.addEvent(event.localPosition),
      onPointerDown: (event) => MouseButtonStateEvent.instance.addEvent(MouseButtonDown()),
      onPointerUp: (event) => MouseButtonStateEvent.instance.addEvent(MouseButtonUp()),
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          if (pointerSignal.scrollDelta.dy < 0) {
            ZoomChangeEvent.instance.addEvent(ZoomIncrease());
          } else {
            ZoomChangeEvent.instance.addEvent(ZoomDecrease());
          }
        }
      },
      child: child,
    );
  }
}
