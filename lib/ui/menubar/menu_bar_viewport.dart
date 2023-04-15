import 'package:flutter/material.dart';
import 'package:nodeflow/ui/divider_horizontal.dart';
import 'package:nodeflow/ui/menubar/menu_bar_controller.dart';
import 'package:nodeflow/ui/menubar/menu_bar_data.dart';
import 'package:nodeflow/ui/menubar/menu_bar_overlay.dart';

class MenuBarViewport extends StatefulWidget {
  final Widget menuBarComponent;
  final Widget viewport;
  const MenuBarViewport({Key? key, required this.viewport, required this.menuBarComponent}) : super(key: key);

  @override
  _MenuBarViewportState createState() => _MenuBarViewportState();
}

class _MenuBarViewportState extends State<MenuBarViewport> {
  final MenuBarController controller = MenuBarController();
  final FocusNode focusNode = FocusNode(skipTraversal: true);
  @override
  Widget build(BuildContext context) {
    return MenuBarData(
      controller: controller,
      child: Column(
        children: [
          widget.menuBarComponent,
          const DividerHorizontal(),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: widget.viewport,
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: MenuBarOverlay(
                    controller: controller,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
