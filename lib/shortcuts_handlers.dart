import 'package:sketching/config/paint_colors.dart';
import 'package:sketching/eventStreams/pencil_color_event.dart';
import 'package:sketching/eventStreams/zoom_change_event.dart';
import 'package:sketching/shortcuts_mapping.dart';

import 'eventStreams/duplicate_event.dart';
import 'eventStreams/focus_event.dart';
import 'eventStreams/redo_event.dart';
import 'eventStreams/reset_event.dart';
import 'eventStreams/save_event.dart';
import 'eventStreams/undo_event.dart';
import 'eventStreams/cursor_state_event.dart';

class ShortcutsHandlers {
  static const handlers = {
    ShortcutsActions.reset: _reset,
    ShortcutsActions.erasing: _erasing,
    ShortcutsActions.dragging: _dragging,
    ShortcutsActions.drawing: _drawing,
    ShortcutsActions.selecting: _selecting,
    ShortcutsActions.undo: _undo,
    ShortcutsActions.redo: _redo,
    ShortcutsActions.focus: _focus,
    ShortcutsActions.zoomIncrease: _zoomIncrease,
    ShortcutsActions.zoomDecrease: _zoomDecrease,
    ShortcutsActions.save: _save,
    ShortcutsActions.duplicate: _duplicate,
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

  static void _selecting() {
    CursorStateEvent.instance.addEvent(CursorSelecting());
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

  static void _zoomIncrease() {
    ZoomChangeEvent.instance.addEvent(ZoomIncrease());
  }

  static void _zoomDecrease() {
    ZoomChangeEvent.instance.addEvent(ZoomDecrease());
  }

  static void _save() {
    SaveEvent.instance.addEvent(true);
  }

  static void _duplicate() {
    DuplicateEvent.instance.addEvent(true);
  }

  static void _color1() {
    PencilColorEvent.instance.addEvent(PaintColors.color1);
  }

  static void _color2() {
    PencilColorEvent.instance.addEvent(PaintColors.color2);
  }

  static void _color3() {
    PencilColorEvent.instance.addEvent(PaintColors.color3);
  }

  static void _color4() {
    PencilColorEvent.instance.addEvent(PaintColors.color4);
  }

  static void _color5() {
    PencilColorEvent.instance.addEvent(PaintColors.color5);
  }
}
