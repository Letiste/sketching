import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sketcher/eventStreams/cursor_state_event.dart';
import 'package:sketcher/eventStreams/mouse_button_state_event.dart';

class CursorAspect {
  static Widget buildCursor(
    MouseButtonState mouseButtonState,
    CursorState cursorState,
    Color pencilColor,
    bool mouseOnScreen,
  ) {
    if (!mouseOnScreen) {
      return Container();
    }
    if (cursorState is CursorDrawing) {
      return buildDrawCursor(mouseButtonState, pencilColor);
    }
    if (cursorState is CursorDragging) {
      return buildDragCursor(mouseButtonState);
    }
    if (cursorState is CursorErasing) {
      return buildEraseCursor(mouseButtonState);
    }
    if (cursorState is CursorSelecting) {
      return buildSelectCursor(mouseButtonState);
    }
    if (cursorState is CursorInSelectingArea) {
      return buildDragCursor(mouseButtonState);
    }
    return Container();
  }

  static Widget buildDrawCursor(MouseButtonState mouseButtonState, Color pencilColor) {
    final icon = mouseButtonState is MouseButtonDown ? Icons.create : Icons.create_outlined;
    return Transform.translate(
      offset: const Offset(-2, -22),
      child: Icon(
        icon,
        color: pencilColor,
      ),
    );
  }

  static Widget buildDragCursor(MouseButtonState mouseButtonState) {
    final asset =
        mouseButtonState is MouseButtonDown ? "assets/hand_back_fist.svg" : "assets/hand.svg";
    return Transform.translate(
      offset: const Offset(-12, -12),
      child: Stack(
        children: [
          Transform.translate(
            offset: const Offset(-1, -1),
            child: SvgPicture.asset(
              asset,
              height: 24,
              // width: 110,
              color: Colors.grey.shade100,
            ),
          ),
          SvgPicture.asset(
            asset,
            height: 22,
            color: Colors.grey.shade900,
          ),
        ],
      ),
    );
  }

  static Widget buildEraseCursor(MouseButtonState mouseButtonState) {
    final color = mouseButtonState is MouseButtonDown ? Colors.grey.shade900 : Colors.transparent;
    return Transform.translate(
      offset: const Offset(-12, -12),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(width: 1, color: Colors.grey.shade100),
        ),
        child: Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(width: 1, color: Colors.grey.shade900),
          ),
        ),
      ),
    );
  }

  static Widget buildSelectCursor(MouseButtonState mouseButtonState) {
    const icon = Icons.add;
    return Transform.translate(
      offset: const Offset(-12, -12),
      child: const Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
