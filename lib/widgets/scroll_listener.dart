import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../eventStreams/scroll_event.dart';

class ScrollListener extends StatelessWidget {
  final Widget child;

  const ScrollListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          ScrollEvent.instance.addEvent(pointerSignal);
        }
      },
      child: child,
    );
  }
}
