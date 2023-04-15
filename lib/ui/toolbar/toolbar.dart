import 'package:flutter/material.dart';
import 'package:nodeflow/i18n/internationalization.dart';

class Toolbar {
  final List<ToolbarItem> items;

  Toolbar(this.items);
}

abstract class ToolbarItem {
  Widget build(BuildContext context);
}

class ToolbarButton extends ToolbarItem {
  final Icon icon;
  final I18n label;
  final void Function()? onPressed;

  ToolbarButton({required this.icon, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class ToolbarComboBoxItem {
  final Icon? icon;
  final I18n label;
  final dynamic value;

  ToolbarComboBoxItem(this.icon, this.label, this.value);
}

class ToolbarComboBox extends ToolbarItem {
  final I18n label;
  final List<ToolbarComboBoxItem> items;

  ToolbarComboBox({required this.label, required this.items});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
