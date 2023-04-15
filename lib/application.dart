import 'package:flutter/material.dart';
import 'package:nodeflow/ui/menubar/menu_bar.dart';
import 'package:nodeflow/ui/toolbar/toolbar.dart';

class Application extends ChangeNotifier {
  final List<Menu> menus = [];
  final List<Toolbar> toolbars = [];

  void refresh() {
    notifyListeners();
  }
}
