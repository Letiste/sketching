import 'package:flutter/material.dart';
import 'package:sketcher/eventStreams/pencil_color_event.dart';
import 'package:sketcher/shortcuts_mapping.dart';

import 'eventStreams/focus_event.dart';
import 'eventStreams/redo_event.dart';
import 'eventStreams/reset_event.dart';
import 'eventStreams/undo_event.dart';
import 'eventStreams/cursor_state_event.dart';

class ShortcutsHandlers {
  static const handlers = {
    ShortcutsActions.reset: _reset,
    ShortcutsActions.erasing: _erasing,
    ShortcutsActions.dragging: _dragging,
    ShortcutsActions.drawing: _drawing,
    ShortcutsActions.undo: _undo,
    ShortcutsActions.redo: _redo,
    ShortcutsActions.focus: _focus,
    ShortcutsActions.color1: _color1,
    ShortcutsActions.color2: _color2,
    ShortcutsActions.color3: _color3,
    ShortcutsActions.color4: _color4,
    ShortcutsActions.color5: _color5,
  };

  static void _reset() {
    ResetEvent.instance.addEvent(true);
  }

  static void _erasing() {
    CursorStateEvent.instance.addEvent(CursorErasing());
  }

  static void _dragging() {
    CursorStateEvent.instance.addEvent(CursorDragging());
  }

  static void _drawing() {
    CursorStateEvent.instance.addEvent(CursorDrawing());
  }

  static void _undo() {
    UndoEvent.instance.addEvent(true);
  }

  static void _redo() {
    RedoEvent.instance.addEvent(true);
  }

  static void _focus() {
    FocusEvent.instance.addEvent(true);
  }

  static void _color1() {
    PencilColorEvent.instance.addEvent(Colors.grey.shade100);
  }

  static void _color2() {
    PencilColorEvent.instance.addEvent(Colors.pink);
  }

  static void _color3() {
    PencilColorEvent.instance.addEvent(Colors.deepPurple);
  }

  static void _color4() {
    PencilColorEvent.instance.addEvent(Colors.teal);
  }

  static void _color5() {
    PencilColorEvent.instance.addEvent(Colors.deepOrange);
  }
}
