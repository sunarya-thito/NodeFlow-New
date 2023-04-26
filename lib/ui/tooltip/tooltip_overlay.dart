import 'package:flutter/material.dart';
import 'package:nodeflow/ui/compact_data.dart';
import 'package:nodeflow/ui/tooltip/tooltip.dart';

class TooltipOverlay extends StatefulWidget {
  final TooltipController controller;
  const TooltipOverlay({Key? key, required this.controller}) : super(key: key);

  @override
  _TooltipOverlayState createState() => _TooltipOverlayState();
}

class _TooltipOverlayState extends State<TooltipOverlay> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTooltipChanged);
  }

  void _onTooltipChanged() {
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant TooltipOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTooltipChanged);
      widget.controller.addListener(_onTooltipChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTooltipChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.isShowing) return const SizedBox();
    var adjustedPosition = widget.controller.position + const Offset(20, 10);
    Offset globalToLocal(Offset global) {
      var renderObj = context.findRenderObject();
      if (renderObj is RenderBox) {
        return renderObj.globalToLocal(global);
      }
      return Offset.zero;
    }

    var localPosition = globalToLocal(adjustedPosition);
    return Stack(children: [
      Positioned(
        left: localPosition.dx,
        top: localPosition.dy,
        child: Container(
          decoration: BoxDecoration(
            color: app().tooltipColor,
            border: Border.all(color: app().dividerColor),
          ),
          child: widget.controller.buildTooltip(context),
        ),
      )
    ]);
  }
}
