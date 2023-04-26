import 'package:flutter/foundation.dart';
import 'package:nodeflow/action.dart';
import 'package:nodeflow/i18n/internationalization_keys.dart';
import 'package:nodeflow/ui/menubar/menu_bar.dart';

class ActionView extends Action<void> {
  static const Key actionKey = Key('action_view');

  ActionView() : super(key: actionKey);

  @override
  ActionHandler<void> createHandler() {
    return ActionViewHandler();
  }
}

class ActionViewHandler extends ActionHandler<void> {
  @override
  Menu? buildMenu() {
    return ActionHandler.newMenu(this, label: I18n.menubar_view);
  }
}
