import 'package:flutter/material.dart';

import 'menu_bar_controller.dart';

class MenuBarData extends InheritedWidget {
  const MenuBarData({
    super.key,
    required this.controller,
    required super.child,
  });

  final MenuBarController controller;

  static MenuBarData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MenuBarData>()!;
  }

  @override
  bool updateShouldNotify(covariant MenuBarData oldWidget) {
    return controller != oldWidget.controller;
  }
}
