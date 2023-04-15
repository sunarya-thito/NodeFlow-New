import 'package:flutter/material.dart';
import 'package:nodeflow/ui/overlay/overlay.dart';
import 'package:nodeflow/ui/overlay/overlay_data.dart';

class OverlayViewport extends StatefulWidget {
  final Widget child;
  const OverlayViewport({Key? key, required this.child}) : super(key: key);

  @override
  OverlayViewportState createState() => OverlayViewportState();
}

class OverlayViewportState extends State<OverlayViewport> {
  // overlay order: [0] = bottom, [n] = top
  final List<OverlayWidget> _overlays = [];

  void closeOverlay(OverlayWidget overlay) {
    setState(() {
      _overlays.remove(overlay);
    });
  }

  void addOverlay(OverlayWidget overlay) {
    // other overlay other than dialog, cannot be stacked
    // also closes every other overlay, dialog also closes every other overlay
    if (overlay.level != OverlayLevel.dialog) {
      // close all overlays (except dialog, )
    } else {}
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return OverlayData(
        viewport: this,
        child: Stack(
          children: [
            widget.child,
          ],
        ));
  }
}
