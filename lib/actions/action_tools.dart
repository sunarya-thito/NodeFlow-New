import 'package:flutter/foundation.dart';
import 'package:nodeflow/action.dart';
import 'package:nodeflow/i18n/internationalization_keys.dart';
import 'package:nodeflow/ui/menubar/menu_bar.dart';

class ActionTools extends Action<void> {
  static const Key actionKey = Key('action_tools');

  ActionTools() : super(key: actionKey);

  @override
  ActionHandler<void> createHandler() {
    return ActionToolsHandler();
  }
}

class ActionToolsHandler extends ActionHandler<void> {
  @override
  Menu? buildMenu() {
    return ActionHandler.newMenu(this, label: I18n.menubar_tools);
  }
}
