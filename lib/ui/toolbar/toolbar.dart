import 'package:flutter/material.dart';
import 'package:nodeflow/hotkey.dart';
import 'package:nodeflow/i18n/internationalization.dart';
import 'package:nodeflow/ui/toolbar/toolbar_button_widget.dart';
import 'package:nodeflow/ui/toolbar/toolbar_combo_box_widget.dart';
import 'package:nodeflow/ui/toolbar/toolbar_toggle_button_widget.dart';

class ToolbarController extends ChangeNotifier {
  ToolbarComboBoxPopup? _opened;

  ToolbarComboBoxPopup? get opened => _opened;

  void open(ToolbarComboBox comboBox, Offset globalOffset) {
    closeOverlay();
    _opened = ToolbarComboBoxPopup(comboBox: comboBox, globalPosition: globalOffset);
    notifyListeners();
  }

  void closeOverlay() {
    if (_opened != null) {
      _opened = null;
      notifyListeners();
    }
  }
}

class Toolbar {
  final List<ToolbarItem> items;

  Toolbar(this.items);

  bool get hasItems => items.where((element) => !element.hidden).isNotEmpty;
}

abstract class ToolbarItem {
  final Key key;
  final bool hidden;
  ToolbarItem({Key? key, this.hidden = false}) : key = key ?? UniqueKey();

  Widget build(BuildContext context);
  ToolbarItem hide();
  ToolbarItem show();
}

class ToolbarToggleButton extends ToolbarButton {
  final bool selected;
  ToolbarToggleButton(
      {this.selected = false, required super.icon, required super.label, super.description, super.keybind, super.onPressed, super.key, super.hidden});

  @override
  Widget build(BuildContext context) {
    return ToolbarToggleButtonWidget(button: this);
  }

  @override
  ToolbarItem hide() {
    return ToolbarToggleButton(
      selected: selected,
      key: key,
      icon: icon,
      label: label,
      onPressed: onPressed,
      hidden: true,
    );
  }

  @override
  ToolbarItem show() {
    return ToolbarToggleButton(
      selected: selected,
      key: key,
      icon: icon,
      label: label,
      onPressed: onPressed,
      hidden: false,
    );
  }
}

class ToolbarButton extends ToolbarItem {
  final Widget icon;
  final Intl label;
  final Intl? description;
  final ShortcutKey? keybind;
  final void Function()? onPressed;

  ToolbarButton({required this.icon, required this.label, this.onPressed, super.key, this.description, this.keybind, super.hidden});

  @override
  Widget build(BuildContext context) {
    return ToolbarButtonWidget(button: this);
  }

  @override
  ToolbarItem hide() {
    return ToolbarButton(
      key: key,
      icon: icon,
      label: label,
      onPressed: onPressed,
      hidden: true,
    );
  }

  @override
  ToolbarItem show() {
    return ToolbarButton(
      key: key,
      icon: icon,
      label: label,
      onPressed: onPressed,
      hidden: false,
    );
  }
}

class ToolbarComboBoxItem {
  final Widget? icon;
  final Intl label;
  final dynamic value;

  ToolbarComboBoxItem(this.icon, this.label, this.value);
}

class ToolbarComboBox<T> extends ToolbarItem {
  final Widget Function(BuildContext context)? header;
  final Widget Function(BuildContext context)? footer;
  final List<ToolbarComboBoxItem> items;
  final int selected;
  final Intl placeholder;
  final void Function(int selected) onChangeSelected;
  final Intl? tooltip;
  final Intl? tooltipDescription;
  final Widget? tooltipIcon;

  ToolbarComboBox(
      {required this.items,
      super.key,
      super.hidden,
      this.selected = -1,
      required this.placeholder,
      this.header,
      this.footer,
      this.tooltip,
      this.tooltipDescription,
      this.tooltipIcon,
      required this.onChangeSelected});

  ToolbarComboBoxItem? get currentValue {
    if (selected < 0 || selected >= items.length) return null;
    return items[selected];
  }

  @override
  Widget build(BuildContext context) {
    return ToolbarComboBoxWidget(comboBox: this);
  }

  @override
  ToolbarItem hide() {
    return ToolbarComboBox(
      key: key,
      items: items,
      hidden: true,
      selected: selected,
      placeholder: placeholder,
      header: header,
      footer: footer,
      onChangeSelected: onChangeSelected,
    );
  }

  @override
  ToolbarItem show() {
    return ToolbarComboBox(
      key: key,
      items: items,
      hidden: false,
      selected: selected,
      placeholder: placeholder,
      header: header,
      footer: footer,
      onChangeSelected: onChangeSelected,
    );
  }
}
