import 'package:flutter/material.dart';
import 'package:nodeflow/hotkey.dart';
import 'package:nodeflow/i18n/internationalization.dart';

class Menu {
  final Key key;
  final Widget? icon;
  final I18n label;
  final List<Menu> items;
  final bool hidden;
  final void Function()? onTap;
  final ShortcutKey? keybind;
  Menu(
      {Key? key,
      required this.label,
      this.items = const [],
      this.icon,
      this.onTap,
      this.keybind,
      this.hidden = false})
      : key = key ?? UniqueKey();

  Menu hide() {
    return Menu(
      key: key,
      label: label,
      items: items,
      icon: icon,
      onTap: onTap,
      keybind: keybind,
      hidden: true,
    );
  }

  Menu show() {
    return Menu(
      key: key,
      label: label,
      items: items,
      icon: icon,
      onTap: onTap,
      keybind: keybind,
      hidden: false,
    );
  }

  List<Menu> get filteredItems =>
      items.where((element) => !element.hidden).toList();

  bool get hasNoChildren => items.where((element) => !element.hidden).isEmpty;
  bool get isDisabled => hasNoChildren && onTap == null;
  bool get closeOnClick => hasNoChildren || onTap != null;
}
