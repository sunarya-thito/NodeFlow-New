import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nodeflow/action.dart' as act;
import 'package:nodeflow/application.dart';

mixin KeybindAction on act.Action {
  ShortcutKey? get shortcutKey {
    return nodeflow.getContext<HotkeyBindings>()._bindings[key];
  }
}

class HotkeyInterceptor extends StatefulWidget {
  final Widget child;

  const HotkeyInterceptor({Key? key, required this.child}) : super(key: key);

  @override
  _HotkeyInterceptorState createState() => _HotkeyInterceptorState();
}

class _HotkeyInterceptorState extends State<HotkeyInterceptor> {
  @override
  void initState() {
    super.initState();
    focusNode = FocusNode(
      onKey: (node, event) {
        if (event is RawKeyDownEvent) {
          if (nodeflow
              .getContext<HotkeyBindings>()
              ._bindings
              .values
              .any((element) => element.accept(event))) {
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  late FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class HotkeyBindings extends Context {
  final Map<Key, ShortcutKey> _bindings = {}; // Key (Action), ShortcutKey

  @override
  void onInitialize() {
    super.onInitialize();
    RawKeyboard.instance.addListener(_onKeyEvent);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_onKeyEvent);
    super.dispose();
  }

  void _onKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      for (var entry in _bindings.entries) {
        if (entry.value.accept(event)) {
          nodeflow
              .getContext<act.ActionContext>()
              .executeActionByKey(entry.key);
        }
      }
    }
  }

  void bind(Key action, ShortcutKey shortcut) {
    _bindings[action] = shortcut;
  }

  bool isBound(ShortcutKey shortcut) {
    return _bindings.values.contains(shortcut);
  }

  void unbind(Key action) {
    _bindings.remove(action);
  }
}

class ShortcutKey {
  static ShortcutKey fromString(String s) {
    final parts = s.split('+');
    final key = parts.last
        .toLowerCase(); // this could be A, B, or even F10 (the f10 key)
    final modifiers = parts.sublist(0, parts.length - 1);
    return ShortcutKey(
      LogicalKeyboardKey.knownLogicalKeys
          .firstWhere((element) => element.keyLabel.toLowerCase() == key),
      modifiers.map((e) => _modifierKeyFromString(e)).toSet(),
    );
  }

  static ModifierKey _modifierKeyFromString(String s) {
    switch (s.toLowerCase()) {
      case 'ctrl':
        return ModifierKey.controlModifier;
      case 'shift':
        return ModifierKey.shiftModifier;
      case 'alt':
        return ModifierKey.altModifier;
      case 'meta':
        return ModifierKey.metaModifier;
      default:
        throw Exception('Invalid modifier key: $s');
    }
  }

  final LogicalKeyboardKey key;
  final Set<ModifierKey> modifiers;

  ShortcutKey(this.key, [this.modifiers = const {}]);

  @override
  bool operator ==(Object other) {
    if (other is ShortcutKey) {
      return other.key == key && other.modifiers == modifiers;
    }
    return false;
  }

  bool accept(RawKeyEvent event) {
    return event.logicalKey == key &&
        event.isControlPressed ==
            modifiers.contains(ModifierKey.controlModifier) &&
        event.isShiftPressed == modifiers.contains(ModifierKey.shiftModifier) &&
        event.isAltPressed == modifiers.contains(ModifierKey.altModifier) &&
        event.isMetaPressed == modifiers.contains(ModifierKey.metaModifier);
  }

  @override
  String toString() {
    String builder = '';
    if (modifiers.contains(ModifierKey.controlModifier)) {
      builder += 'Ctrl+';
    }
    if (modifiers.contains(ModifierKey.shiftModifier)) {
      builder += 'Shift+';
    }
    if (modifiers.contains(ModifierKey.altModifier)) {
      builder += 'Alt+';
    }
    if (modifiers.contains(ModifierKey.metaModifier)) {
      builder += 'Meta+';
    }
    builder += key.keyLabel;
    return builder;
  }

  @override
  int get hashCode => key.hashCode ^ modifiers.hashCode;
}
