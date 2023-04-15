import 'package:flutter/material.dart';
import 'package:nodeflow/ui/menubar/menu_bar.dart';

class MenuComponent extends StatefulWidget {
  final Menu menu;
  const MenuComponent({Key? key, required this.menu}) : super(key: key);

  @override
  _MenuComponentState createState() => _MenuComponentState();
}

class _MenuComponentState extends State<MenuComponent> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
