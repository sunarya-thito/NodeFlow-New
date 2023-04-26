import 'package:flutter/material.dart';
import 'package:nodeflow/ui/compact_data.dart';
import 'package:nodeflow/ui/toolbar/toolbar.dart';
import 'package:nodeflow/ui/tooltip/tooltip_wrapper.dart';

class ToolbarButtonWidget extends StatefulWidget {
  final ToolbarButton button;
  const ToolbarButtonWidget({Key? key, required this.button}) : super(key: key);

  @override
  _ToolbarButtonWidgetState createState() => _ToolbarButtonWidgetState();
}

class _ToolbarButtonWidgetState extends State<ToolbarButtonWidget> {
  bool _hovered = false;
  bool _down = false;

  // final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TooltipWrapper(
      tooltip: TooltipWrapper.actionTooltip(widget.button.label,
          widget.button.description, widget.button.icon, widget.button.keybind),
      child: GestureDetector(
        onTap: () {
          if (widget.button.onPressed != null) {
            widget.button.onPressed!();
          }
        },
        child: Listener(
          onPointerDown: (_) => setState(() => _down = true),
          onPointerUp: (_) => setState(() => _down = false),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: _down
                  ? app().buttonDown
                  : _hovered
                      ? app().buttonHovered
                      : null,
              borderRadius: BorderRadius.circular(2),
            ),
            child: IconTheme(
                data: IconThemeData(size: 16, color: app().primaryTextColor),
                child: widget.button.icon),
          ),
        ),
      ),
    );
  }
}
