import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:sketcher/shortcuts_handlers.dart';

enum ShortcutsActions {
  reset,
  erasing,
  dragging,
  drawing,
  selecting,
  undo,
  redo,
  focus,
  zoomIncrease,
  zoomDecrease,
  save,
  duplicate,
  color1,
  color2,
  color3,
  color4,
  color5,
}

class ShortcutsMapping {
  static const Map<ShortcutActivator, ShortcutsActions> _shortcutsMapping = {
    SingleActivator(LogicalKeyboardKey.keyR): ShortcutsActions.reset,
    SingleActivator(LogicalKeyboardKey.keyE): ShortcutsActions.erasing,
    SingleActivator(LogicalKeyboardKey.keyH): ShortcutsActions.dragging,
    SingleActivator(LogicalKeyboardKey.keyD): ShortcutsActions.drawing,
    SingleActivator(LogicalKeyboardKey.keyS): ShortcutsActions.selecting,
    SingleActivator(LogicalKeyboardKey.keyZ, control: true): ShortcutsActions.undo,
    SingleActivator(LogicalKeyboardKey.keyY, control: true): ShortcutsActions.redo,
    SingleActivator(LogicalKeyboardKey.keyF): ShortcutsActions.focus,
    SingleActivator(LogicalKeyboardKey.numpad1): ShortcutsActions.color1,
    CharacterActivator('&'): ShortcutsActions.color1,
    SingleActivator(LogicalKeyboardKey.numpad2): ShortcutsActions.color2,
    CharacterActivator('é'): ShortcutsActions.color2,
    SingleActivator(LogicalKeyboardKey.numpad3): ShortcutsActions.color3,
    CharacterActivator('"'): ShortcutsActions.color3,
    SingleActivator(LogicalKeyboardKey.numpad4): ShortcutsActions.color4,
    CharacterActivator("'"): ShortcutsActions.color4,
    SingleActivator(LogicalKeyboardKey.numpad5): ShortcutsActions.color5,
    CharacterActivator("("): ShortcutsActions.color5,
    SingleActivator(LogicalKeyboardKey.numpadAdd, control: true): ShortcutsActions.zoomIncrease,
    SingleActivator(LogicalKeyboardKey.numpadSubtract, control: true):
        ShortcutsActions.zoomDecrease,
    SingleActivator(LogicalKeyboardKey.keyS, control: true): ShortcutsActions.save,
    SingleActivator(LogicalKeyboardKey.keyD, control: true): ShortcutsActions.duplicate,
  };

  static Map<ShortcutActivator, void Function()> get shortcutsMapping {
    if (ShortcutsActions.values.length != ShortcutsHandlers.handlers.length) {
      throw Exception("All shortcuts actions should have a handler associated");
    }
    Map<ShortcutActivator, void Function()> map = {};
    for (var entry in _shortcutsMapping.entries) {
      map[entry.key] = ShortcutsHandlers.handlers[entry.value]!;
    }
    return map;
  }
}
