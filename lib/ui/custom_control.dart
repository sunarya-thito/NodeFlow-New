import 'package:flutter/material.dart';

enum ControlState {
  normal,
  hovered,
  focused,
  down;
}

class CustomControl extends StatefulWidget {
  final void Function()? onTap;
  final Widget Function(BuildContext context, ControlState state) builder;
  const CustomControl({Key? key, this.onTap, required this.builder}) : super(key: key);

  @override
  _CustomControlState createState() => _CustomControlState();
}

class _CustomControlState extends State<CustomControl> {
  bool _hovered = false;
  bool _down = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapUp: (e) => setState(() => _down = false),
      child: FocusableActionDetector(
          mouseCursor: SystemMouseCursors.click,
          onShowFocusHighlight: (focused) => setState(() => _focused = focused),
          onShowHoverHighlight: (hovered) => setState(() => _hovered = hovered),
          child: widget.builder(
              context,
              _down
                  ? ControlState.down
                  : _hovered
                      ? ControlState.hovered
                      : _focused
                          ? ControlState.focused
                          : ControlState.normal)),
    );
  }
}
