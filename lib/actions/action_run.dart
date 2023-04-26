import 'package:flutter/cupertino.dart' as cup;
import 'package:flutter/foundation.dart';
import 'package:nodeflow/action.dart';
import 'package:nodeflow/hotkey.dart';
import 'package:nodeflow/i18n/internationalization_keys.dart';
import 'package:nodeflow/ui/menubar/menu_bar.dart';
import 'package:nodeflow/ui/toolbar/toolbar.dart';

class ActionRun extends Action<void> with KeybindAction {
  static const Key actionKey = Key('action_run');

  ActionRun() : super(key: actionKey);

  @override
  ActionHandler<void> createHandler() {
    return ActionRunHandler();
  }
}

class ActionRunHandler extends ActionHandler<void> {
  @override
  Menu? buildMenu() {
    return ActionHandler.newMenu(this,
        label: I18n.quickaccess_run,
        icon: const cup.Icon(
          cup.CupertinoIcons.play_fill,
          color: cup.CupertinoColors.activeGreen,
        ));
  }

  @override
  ToolbarItem? buildToolbar() {
    return ActionHandler.newToolbarButton(this,
        label: I18n.quickaccess_run,
        description: I18n.tooltip_quickaccess_run,
        icon: const cup.Icon(
          cup.CupertinoIcons.play_fill,
          color: cup.CupertinoColors.activeGreen,
        ));
  }
}
