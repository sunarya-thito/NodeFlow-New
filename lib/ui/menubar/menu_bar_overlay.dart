import 'package:flutter/material.dart';
import 'package:nodeflow/ui/menubar/menu_bar_controller.dart';

class MenuBarOverlay extends StatefulWidget {
  final MenuBarController controller;
  const MenuBarOverlay({Key? key, required this.controller}) : super(key: key);

  @override
  _MenuBarOverlayState createState() => _MenuBarOverlayState();
}

class _MenuBarOverlayState extends State<MenuBarOverlay> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(update);
  }

  @override
  void dispose() {
    widget.controller.removeListener(update);
    super.dispose();
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.shownPopup.isEmpty) return const SizedBox();
    Offset globalToLocal(Offset global) {
      final rObj = context.findRenderObject();
      if (rObj == null) {
        return Offset.zero;
      }
      final rBox = rObj as RenderBox;
      return rBox.globalToLocal(global);
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      // onPointerDown: (e) {
      //   widget.controller.closeAll();
      // },
      onTap: () {
        widget.controller.closeAll();
      },
      child: Stack(
        children: widget.controller.shownPopup.map((e) {
          var offset = globalToLocal(e.globalOffset);
          return Positioned(
            left: offset.dx,
            top: offset.dy,
            child: e,
          );
        }).toList(),
      ),
    );
  }
}
