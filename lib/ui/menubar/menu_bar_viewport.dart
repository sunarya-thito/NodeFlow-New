import 'package:flutter/material.dart';
import 'package:nodeflow/ui/divider_horizontal.dart';
import 'package:nodeflow/ui/menubar/menu_bar_controller.dart';
import 'package:nodeflow/ui/menubar/menu_bar_data.dart';
import 'package:nodeflow/ui/menubar/menu_bar_overlay.dart';
import 'package:nodeflow/ui/overlay/overlay_controller.dart';

class MenuBarViewport extends StatefulWidget {
  final OverlayController overlayController;
  final Widget menuBarComponent;
  final Widget viewport;
  const MenuBarViewport(
      {Key? key,
      required this.viewport,
      required this.menuBarComponent,
      required this.overlayController})
      : super(key: key);

  @override
  _MenuBarViewportState createState() => _MenuBarViewportState();
}

class _MenuBarViewportState extends State<MenuBarViewport> {
  final MenuBarController controller = MenuBarController();
  final FocusNode focusNode = FocusNode(skipTraversal: true);
  late MenuBarOverlay overlay;

  @override
  void initState() {
    super.initState();
    overlay = MenuBarOverlay(controller: controller);
    widget.overlayController.menubar.add(overlay);
  }

  @override
  void didUpdateWidget(covariant MenuBarViewport oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.overlayController != widget.overlayController) {
      oldWidget.overlayController.menubar.remove(overlay);
      oldWidget.overlayController.menubar.add(overlay);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    widget.overlayController.menubar.remove(overlay);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MenuBarData(
      controller: controller,
      child: Column(
        children: [
          widget.menuBarComponent,
          const DividerHorizontal(),
          Expanded(
            child: widget.viewport,
          ),
        ],
      ),
    );
  }
}
