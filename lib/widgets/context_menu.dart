import 'package:flutter/material.dart' hide MenuItem;
import 'package:native_context_menu/native_context_menu.dart';
import 'package:sketcher/config/paint_colors.dart';
import 'package:sketcher/eventStreams/pencil_color_event.dart';

import '../eventStreams/cursor_state_event.dart';

class ContextMenu extends StatelessWidget {
  final Widget child;
  const ContextMenu({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      onItemSelected: (item) => item.onSelected!(),
      menuItems: [
        MenuItem(
          title: "Colors",
          items: [
            MenuItem(
              title: "White",
              onSelected: () => PencilColorEvent.instance.addEvent(PaintColors.color1),
            ),
            MenuItem(
              title: "Pink",
              onSelected: () => PencilColorEvent.instance.addEvent(PaintColors.color2),
            ),
            MenuItem(
              title: "Purple",
              onSelected: () => PencilColorEvent.instance.addEvent(PaintColors.color3),
            ),
            MenuItem(
              title: "Teal",
              onSelected: () => PencilColorEvent.instance.addEvent(PaintColors.color4),
            ),
            MenuItem(
              title: "Orange",
              onSelected: () => PencilColorEvent.instance.addEvent(PaintColors.color5),
            ),
          ],
        ),
        MenuItem(
          title: "Draw",
          onSelected: () => CursorStateEvent.instance.addEvent(CursorDrawing()),
        ),
        MenuItem(
          title: "Erase",
          onSelected: () => CursorStateEvent.instance.addEvent(CursorErasing()),
        ),
        MenuItem(
          title: "Drag",
          onSelected: () => CursorStateEvent.instance.addEvent(CursorDragging()),
        ),
        MenuItem(
          title: "Select",
          onSelected: () => CursorStateEvent.instance.addEvent(CursorSelecting()),
        ),
      ],
      child: child,
    );
  }
}
