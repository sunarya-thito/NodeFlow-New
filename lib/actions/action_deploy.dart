import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as mat;
import 'package:nodeflow/action.dart';
import 'package:nodeflow/hotkey.dart';
import 'package:nodeflow/i18n/internationalization.dart';
import 'package:nodeflow/ui/menubar/menu_bar.dart';
import 'package:nodeflow/ui/toolbar/toolbar.dart';

class ActionDeploy extends Action<void> with KeybindAction {
  static const Key actionKey = Key('action_deploy');

  ActionDeploy() : super(key: actionKey);

  @override
  ActionHandler<void> createHandler() {
    return ActionDeployHandler();
  }
}

class ActionDeployHandler extends ActionHandler<void> {
  @override
  Menu? createMenu() {
    return ActionHandler.newMenu(this,
        label: I18n.quickaccess_deploy,
        icon: const mat.Icon(
          mat.Icons.build,
          color: mat.Colors.blue,
        ));
  }

  @override
  ToolbarItem? createToolbar() {
    return ActionHandler.newToolbarButton(this,
        label: I18n.quickaccess_deploy,
        description: I18n.tooltip_quickaccess_deploy,
        icon: const mat.Icon(
          mat.Icons.build,
          color: mat.Colors.blue,
        ));
  }

  @override
  void execute(void value) {
    super.execute(value);
    print('ActionDeploy');
  }
}
