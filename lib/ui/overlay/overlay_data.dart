import 'package:flutter/material.dart';
import 'package:nodeflow/ui/overlay/overlay_viewport.dart';

class OverlayData extends InheritedWidget {
  final OverlayViewportState viewport;

  const OverlayData({
    Key? key,
    required Widget child,
    required this.viewport,
  }) : super(key: key, child: child);

  static OverlayData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<OverlayData>()!;
  }

  @override
  bool updateShouldNotify(covariant OverlayData oldWidget) {
    return viewport != oldWidget.viewport;
  }
}
