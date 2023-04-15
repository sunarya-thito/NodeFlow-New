import 'package:flutter/material.dart';

class NavigationTopBar extends StatefulWidget {
  final List<Widget> children;
  const NavigationTopBar({Key? key, required this.children}) : super(key: key);

  @override
  _NavigationTopBarState createState() => _NavigationTopBarState();
}

class _NavigationTopBarState extends State<NavigationTopBar> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.children,
        ),
      ),
    );
  }
}
