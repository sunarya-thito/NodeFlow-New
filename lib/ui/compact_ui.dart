import 'package:flutter/material.dart';
import 'package:nodeflow/hotkey.dart';
import 'package:nodeflow/ui/compact_data.dart';
import 'package:nodeflow/ui/overlay/overlay_controller.dart';
import 'package:nodeflow/ui/overlay/overlay_viewport.dart';

class CompactUI extends StatefulWidget {
  final Widget child;
  const CompactUI({Key? key, required this.child}) : super(key: key);

  @override
  _CompactUIState createState() => _CompactUIState();
}

class _CompactUIState extends State<CompactUI> {
  final OverlayController overlayController = OverlayController();
  @override
  Widget build(BuildContext context) {
    return CompactData(
      child: Builder(
        builder: (context) {
          return HotkeyInterceptor(
              child: OverlayViewport(
            controller: overlayController,
            child: Container(
              color: CompactData.of(context).backgroundColor,
              child: widget.child,
            ),
          ));
        },
      ),
    );
  }
}
