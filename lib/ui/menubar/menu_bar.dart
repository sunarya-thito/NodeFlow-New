import 'package:flutter/material.dart';
import 'package:nodeflow/i18n/internationalization.dart';

class Menu {
  final Widget? icon;
  final I18n label;
  final List<Menu>? items;
  Menu({required this.label, this.items, this.icon});

  bool get isDisabled => items == null || items!.isEmpty;
  bool get closeOnClick => items == null || items!.isEmpty;
}

class MenuButton extends Menu {
  final void Function()? onTap;

  MenuButton({required super.label, this.onTap, super.icon, super.items});

  @override
  bool get closeOnClick => super.closeOnClick && onTap != null;

  @override
  bool get isDisabled => onTap == null && super.isDisabled;
}
