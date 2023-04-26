import 'package:flutter/material.dart';
import 'package:nodeflow/ui/overlay/overlay_controller.dart';
import 'package:nodeflow/ui/overlay/overlay_data.dart';

class OverlayViewport extends StatefulWidget {
  final OverlayController controller;
  final Widget child;
  const OverlayViewport(
      {Key? key, required this.controller, required this.child})
      : super(key: key);

  @override
  OverlayViewportState createState() => OverlayViewportState();
}

class OverlayViewportState extends State<OverlayViewport> {
  void update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(update);
  }

  @override
  void didUpdateWidget(covariant OverlayViewport oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(update);
      widget.controller.addListener(update);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayData(
      viewport: this,
      child: Stack(
        children: [
          widget.child,
          ...widget.controller.layers
              .map(
                (e) => Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: OverlayLayerViewport(
                      layerController: e,
                    )),
              )
              .toList()
        ],
      ),
    );
  }
}

class OverlayLayerViewport extends StatefulWidget {
  final OverlayLayer layerController;
  const OverlayLayerViewport({Key? key, required this.layerController})
      : super(key: key);

  @override
  OverlayLayerViewportState createState() => OverlayLayerViewportState();
}

class OverlayLayerViewportState extends State<OverlayLayerViewport> {
  void update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.layerController.addListener(update);
  }

  @override
  void didUpdateWidget(covariant OverlayLayerViewport oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.layerController != widget.layerController) {
      oldWidget.layerController.removeListener(update);
      widget.layerController.addListener(update);
    }
  }

  @override
  void dispose() {
    widget.layerController.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: widget.layerController.children,
    );
  }
}
