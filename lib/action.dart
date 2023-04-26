import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:nodeflow/application.dart';
import 'package:nodeflow/hotkey.dart';
import 'package:nodeflow/i18n/internationalization.dart';
import 'package:nodeflow/ui/menubar/menu_bar.dart';
import 'package:nodeflow/ui/toolbar/toolbar.dart';

class ActionContext extends Context {
  final Map<Key?, List<ActionHandler>> _actions =
      {}; // Parent, Children (Actions)

  List<Menu>? _menus;
  List<Toolbar>? _toolbars;

  List<Menu> get menus => _menus!;
  List<Toolbar> get toolbars => _toolbars!;

  void executeActionByKey(Key key, [dynamic value]) {
    for (var handler in _actions.values.flattened) {
      if (handler.action.key == key) {
        handler.execute(value);
        return;
      }
    }
    throw Exception('Action not registered');
  }

  void executeAction<T>(Action<T> action, [T? value]) {
    // regardless which parent, they're still the same, right?
    for (var handler in _actions.values.flattened) {
      if (handler._action == action) {
        handler.execute(value);
        return;
      }
    }
    throw Exception('Action not registered');
  }

  @override
  void onInitialize() {
    super.onInitialize();
    rebuildActions();
    for (var handler in _actions.values.flattened) {
      handler.onInitialize();
    }
  }

  void registerAction(Action action, {Key? parent}) {
    if (_actions[parent] == null) {
      _actions[parent] = [];
    }
    _actions[parent]!.add(ActionAccessor.createHandler(action, nodeflow));
    if (nodeflow.isInitialized) {
      // warn: action must be registered before the application is initialized
      // this would rebuild the entire menu bar and will cause a small lag
      if (!kIgnoreWarnings)
        print(
            'warn: an action was registered after the application was initialized');
      rebuildActions();
    }
  }

  // this unregisters action from all parents
  void unregisterAll(Action action) {
    for (var entry in _actions.entries) {
      entry.value.removeWhere((element) => element._action == action);
    }
    if (nodeflow.isInitialized) {
      if (!kIgnoreWarnings)
        print(
            'warn: an action was unregistered after the application was initialized');
      rebuildActions();
    }
  }

  void unregisterAction(Action action, {Key? parent}) {
    if (_actions[parent] == null) {
      throw Exception('Action not registered');
    }
    _actions[parent]!.removeWhere((element) => element._action == action);
    if (nodeflow.isInitialized) {
      if (!kIgnoreWarnings)
        print(
            'warn: an action was unregistered after the application was initialized');
      rebuildActions();
    }
  }

  void rebuildActions() {
    _menus = _buildMenus();
    _toolbars = _buildToolbars();
    notifyListeners();
  }

  List<Toolbar> _buildToolbars() {
    List<Toolbar> toolbars = [];
    for (var entry in _actions.entries) {
      List<ToolbarItem> items = [];
      for (var handler in entry.value) {
        var item = ActionAccessor.createToolbar(handler);
        if (item != null) {
          items.add(item);
        }
      }
      if (items.isNotEmpty) {
        var toolbar = Toolbar(items);
        toolbars.add(toolbar);
      }
    }
    return toolbars;
  }

  List<Menu> _buildMenus() {
    return _buildSubMenu(null) ?? [];
  }

  void _rebuildAction(ActionHandler handler) {
    if (!ActionAccessor.replaceMenu(handler, _menus ?? [])) {
      // cant find the menu, maybe it was not added?
      // rebuild everything!
      _menus = _buildMenus();
    }
    if (!ActionAccessor.replaceToolbar(handler, _toolbars ?? [])) {
      _toolbars = _buildToolbars();
    }
    notifyListeners();
    return;
  }

  List<Menu>? _buildSubMenu(Key? parent) {
    var action = _actions[parent];
    if (action == null) return null;
    List<Menu> menus = [];
    for (var root in action) {
      var menu = ActionAccessor.createMenu(root);
      if (menu == null) continue;
      var items = _buildSubMenu(root.action.key) ?? [];
      menu.items.addAll(items);
      menus.add(menu);
    }
    return menus;
  }
}

class ActionAccessor {
  static ActionHandler createHandler(Action action, Application application) {
    var handler = action.createHandler();
    handler._action = action;
    return handler;
  }

  static Menu? createMenu(ActionHandler handler) {
    var menu = handler.createMenu();
    if (menu != null && menu.key != handler._action.key) {
      throw Exception('Menu key must be the same as the action key');
    }
    return menu;
  }

  static ToolbarItem? createToolbar(ActionHandler handler) {
    var toolbar = handler.createToolbar();
    if (toolbar != null && toolbar.key != handler._action.key) {
      throw Exception('Toolbar key must be the same as the action key');
    }
    return toolbar;
  }

  static bool replaceToolbar(ActionHandler handler, List<Toolbar> allToolbars) {
    bool found = false;
    var toolbar = handler.createToolbar();
    for (var i = 0; i < allToolbars.length; i++) {
      var tb = allToolbars[i];
      for (var j = 0; j < tb.items.length; j++) {
        if (tb.items[j].key == handler.action.key) {
          found = true;
          if (toolbar != null) {
            tb.items[j] = toolbar;
          } else {
            tb.items[j] = tb.items[j].hide();
          }
        }
      }
    }
    return found;
  }

  // if returns false, the action is not registered
  static bool replaceMenu(ActionHandler handler, List<Menu> allMenus) {
    var menu = handler.createMenu();
    return _replaceMenu(handler, menu, allMenus);
  }

  static bool _replaceMenu(
      ActionHandler handler, Menu? menu, List<Menu> allMenus) {
    bool found = false;
    for (var i = 0; i < allMenus.length; i++) {
      if (allMenus[i].key == handler.action.key) {
        found = true;
        if (menu != null) {
          var oldSubmenu = allMenus[i].items;
          allMenus[i] = menu;
          // add back oldSubmenu (excluding menu with _ValueKey)
          for (var j = 0; j < oldSubmenu.length; j++) {
            if (oldSubmenu[j].key is! _ValueKey) {
              allMenus[i].items.add(oldSubmenu[j]);
            }
          }
        } else {
          allMenus[i] = allMenus[i].hide();
        }
      }
      found |= _replaceMenu(handler, menu, allMenus[i].items);
    }
    return found;
  }
}

class _ValueKey extends UniqueKey {}

abstract class Action<T> {
  final Key key;

  Action({Key? key}) : key = key ?? UniqueKey();

  ActionHandler<T> createHandler();
}

abstract class ActionHandler<T> {
  late Action<T> _action;

  Action<T> get action => _action;

  C getContext<C extends Context>() {
    return nodeflow.getContext<C>();
  }

  void addDependency<C extends Context>() {
    getContext<C>().addListener(update);
  }

  void removeDependency<C extends Context>() {
    getContext<C>().removeListener(update);
  }

  void update() {
    getContext<ActionContext>()._rebuildAction(this);
  }

  void onInitialize() {}

  static const List<ActionValue<bool>> checkboxValues = [
    ActionValue<bool>(value: true, label: null),
    ActionValue<bool>(value: false, label: null),
  ]; // values for checkbox

  static ToolbarItem newToolbarButton(ActionHandler actionHandler,
      {required I18n label,
      required Widget icon,
      bool enabled = true,
      I18n? description}) {
    return ToolbarButton(
        icon: icon,
        label: label,
        description: description,
        keybind: actionHandler.action is KeybindAction
            ? (actionHandler.action as KeybindAction).shortcutKey
            : null,
        onPressed: enabled
            ? () {
                actionHandler._execute(null);
              }
            : null,
        key: actionHandler.action.key);
  }

  static ToolbarItem newToolbarToggleButton(ActionHandler actionHandler,
      {required I18n label,
      required Widget icon,
      bool enabled = true,
      bool selected = false,
      I18n? description}) {
    return ToolbarToggleButton(
        icon: icon,
        label: label,
        selected: selected,
        description: description,
        keybind: actionHandler.action is KeybindAction
            ? (actionHandler.action as KeybindAction).shortcutKey
            : null,
        onPressed: enabled
            ? () {
                actionHandler._execute(!selected);
              }
            : null,
        key: actionHandler.action.key);
  }

  static ToolbarItem newToolbarComboBox<T>(
    ActionHandler<T> actionHandler, {
    required I18n label,
    required List<ActionValue<T>> values,
    int selected = -1,
    bool enabled = true,
    Widget Function(BuildContext)? header,
    Widget Function(BuildContext)? footer,
    T? value,
    I18n? tooltip,
    I18n? tooltipDescription,
    Widget? tooltipIcon,
  }) {
    if (value != null && selected == -1) {
      selected = values.indexWhere((e) => e.value == value);
    }
    var toolbarComboBox = ToolbarComboBox(
      placeholder: label,
      onChangeSelected: (selected) {
        actionHandler._execute(values[selected].value);
      },
      header: header,
      footer: footer,
      tooltip: tooltip,
      tooltipDescription: tooltipDescription,
      tooltipIcon: tooltipIcon,
      items: enabled
          ? values
              .map((e) =>
                  ToolbarComboBoxItem(e.icon, e.label ?? I18n.empty, e.value))
              .toList()
          : [],
      selected: selected,
      key: actionHandler.action.key,
    );
    return toolbarComboBox;
  }

  static Menu newMenu<T>(
    ActionHandler<T> actionHandler, {
    required I18n label,
    Widget? icon,
    List<ActionValue<T>>? values,
    bool enabled = true,
    int selected = -1,
    T? value,
  }) {
    if (values != null && value != null && selected == -1) {
      selected = values.indexWhere((e) => e.value == value);
    }
    if (values == checkboxValues) {
      // check for checkbox values
      return Menu(
          key: actionHandler.action.key,
          label: label,
          icon: value == true ? const Icon(Icons.check) : null,
          onTap: () {
            actionHandler._execute(!((value ?? false) as bool) as T?);
          },
          keybind: actionHandler.action is KeybindAction
              ? (actionHandler.action as KeybindAction).shortcutKey
              : null);
    }
    List<Menu> items = [];
    if (values != null) {
      for (var i = 0; i < values.length; i++) {
        var value = values[i];
        items.add(Menu(
          icon: selected == i ? const Icon(Icons.check) : null,
          key: _ValueKey(),
          label: value.label ?? I18n.empty,
          onTap: () {
            actionHandler._execute(value.value);
          },
        ));
      }
    }
    return Menu(
        key: actionHandler.action.key,
        icon: icon,
        items: items,
        label: label,
        keybind: actionHandler.action is KeybindAction
            ? (actionHandler.action as KeybindAction).shortcutKey
            : null,
        onTap: enabled
            ? () {
                actionHandler._execute(null);
              }
            : null);
  }

  void _execute(T? value) {
    execute(value);
  }

  void execute(T? value) {}

  Menu? createMenu() {}

  ToolbarItem? createToolbar() {}
}

class ActionValue<T> {
  final Widget? icon;
  final I18n? label;
  final T? value;
  const ActionValue({this.label, this.value, this.icon});
}
