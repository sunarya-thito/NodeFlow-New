import 'package:flutter/material.dart';
import 'package:nodeflow/ui/overlay/overlay_controller.dart';
import 'package:nodeflow/ui/tooltip/tooltip.dart';
import 'package:nodeflow/ui/tooltip/tooltip_overlay.dart';

class TooltipViewport extends StatefulWidget {
  final OverlayController overlayController;
  final Widget child;
  const TooltipViewport(
      {Key? key, required this.child, required this.overlayController})
      : super(key: key);

  @override
  State<TooltipViewport> createState() => _TooltipViewportState();
}

class _TooltipViewportState extends State<TooltipViewport> {
  final TooltipController controller = TooltipController();
  late TooltipOverlay tooltipOverlay;

  @override
  void initState() {
    super.initState();
    tooltipOverlay = TooltipOverlay(controller: controller);
    widget.overlayController.tooltip.add(tooltipOverlay);
  }

  @override
  void didUpdateWidget(covariant TooltipViewport oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.overlayController != widget.overlayController) {
      oldWidget.overlayController.tooltip.remove(tooltipOverlay);
      widget.overlayController.tooltip.add(tooltipOverlay);
    }
  }

  @override
  void dispose() {
    widget.overlayController.tooltip.remove(tooltipOverlay);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TooltipData(
      controller: controller,
      child: widget.child,
    );
  }
}

class TooltipData extends InheritedWidget {
  final TooltipController controller;

  const TooltipData({Key? key, required this.controller, required Widget child})
      : super(key: key, child: child);

  static TooltipData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TooltipData>()!;
  }

  @override
  bool updateShouldNotify(covariant TooltipData oldWidget) {
    return oldWidget.controller != controller;
  }
}
