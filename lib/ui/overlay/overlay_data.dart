import 'package:flutter/material.dart';
import 'package:nodeflow/ui/overlay/overlay_viewport.dart';

class OverlayData extends InheritedWidget {
  final OverlayViewportState viewport;

  const OverlayData({super.key, required this.viewport, required super.child});

  static OverlayData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<OverlayData>()!;
  }

  @override
  bool updateShouldNotify(OverlayData oldWidget) {
    return viewport != oldWidget.viewport;
  }
}
