import 'package:flutter/foundation.dart';
import 'package:nodeflow/action.dart';
import 'package:nodeflow/i18n/internationalization.dart';
import 'package:nodeflow/i18n/internationalization_keys.dart';
import 'package:nodeflow/project/project.dart';
import 'package:nodeflow/ui/toolbar/toolbar.dart';

class ActionBuildConfiguration extends Action<BuildConfiguration> {
  static const Key actionKey = Key('action_build_configuration');

  ActionBuildConfiguration() : super(key: actionKey);

  @override
  ActionHandler<BuildConfiguration> createHandler() {
    return ActionBuildConfigurationHandler();
  }
}

class ActionBuildConfigurationHandler extends ActionHandler<BuildConfiguration> {
  @override
  void execute(BuildConfiguration? value) {
    super.execute(value);
    print('ActionBuildConfiguration: $value');
  }

  @override
  ToolbarItem? buildToolbar() {
    return ActionHandler.newToolbarComboBox(this,
        label: I18n.quickaccess_build_configuration,
        tooltip: I18n.quickaccess_build_configuration,
        tooltipDescription: I18n.tooltip_quickaccess_build_configuration,
        values: [
          ActionValue(label: Intl('TEST')),
          ActionValue(label: Intl('HELLO')),
        ],
        value: null);
  }
}
