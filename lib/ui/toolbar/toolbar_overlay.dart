import 'package:flutter/material.dart';
import 'package:nodeflow/ui/toolbar/toolbar.dart';
import 'package:nodeflow/ui/toolbar/toolbar_viewport.dart';

class ToolbarOverlay extends StatefulWidget {
  final ToolbarController controller;
  const ToolbarOverlay({Key? key, required this.controller}) : super(key: key);

  @override
  _ToolbarOverlayState createState() => _ToolbarOverlayState();
}

class _ToolbarOverlayState extends State<ToolbarOverlay> {
  void update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(update);
  }

  @override
  void didUpdateWidget(covariant ToolbarOverlay oldWidget) {
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
    Offset globalToLocal(Offset global) {
      final rObj = context.findRenderObject();
      if (rObj == null) {
        return Offset.zero;
      }
      final rBox = rObj as RenderBox;
      return rBox.globalToLocal(global);
    }

    if (widget.controller.opened == null) return const SizedBox();
    var localPosition = globalToLocal(widget.controller.opened!.globalPosition);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      // onPointerDown: (e) {
      //   widget.controller.closeOverlay();
      // },
      onTap: () {
        widget.controller.closeOverlay();
      },
      child: Stack(children: [
        Positioned(
          top: localPosition.dy,
          left: localPosition.dx,
          child: ToolbarData(
            controller: widget.controller,
            child: widget.controller.opened!,
          ),
        ),
      ]),
    );
  }
}
