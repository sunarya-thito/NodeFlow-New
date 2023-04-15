import 'package:flutter/material.dart';

class TooltipWrapper extends StatefulWidget {
  final Widget Function(BuildContext context) tooltip;
  final Widget child;
  const TooltipWrapper({Key? key, required this.child, required this.tooltip}) : super(key: key);

  @override
  _TooltipWrapperState createState() => _TooltipWrapperState();
}

class _TooltipWrapperState extends State<TooltipWrapper> {
  Offset? globalTooltipPosition;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        // wait for few milliseconds before showing tooltip
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              globalTooltipPosition = event.position;
            });
          }
        });
      },
      onHover: (event) {},
      onExit: (event) {},
      child: widget.child,
    );
  }
}
