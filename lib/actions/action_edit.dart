import 'package:flutter/foundation.dart';
import 'package:nodeflow/action.dart';
import 'package:nodeflow/i18n/internationalization.dart';
import 'package:nodeflow/ui/menubar/menu_bar.dart';

class ActionEdit extends Action<void> {
  static const Key actionKey = Key('action_edit');

  ActionEdit() : super(key: actionKey);

  @override
  ActionHandler<void> createHandler() {
    return ActionEditHandler();
  }
}

class ActionEditHandler extends ActionHandler<void> {
  @override
  Menu? createMenu() {
    return ActionHandler.newMenu(this, label: I18n.menubar_edit);
  }
}
