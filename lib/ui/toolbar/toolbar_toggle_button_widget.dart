import 'package:flutter/material.dart';
import 'package:nodeflow/ui/compact_data.dart';
import 'package:nodeflow/ui/toolbar/toolbar.dart';
import 'package:nodeflow/ui/tooltip/tooltip_wrapper.dart';

class ToolbarToggleButtonWidget extends StatefulWidget {
  final ToolbarToggleButton button;
  const ToolbarToggleButtonWidget({Key? key, required this.button})
      : super(key: key);

  @override
  _ToolbarToggleButtonWidgetState createState() =>
      _ToolbarToggleButtonWidgetState();
}

class _ToolbarToggleButtonWidgetState extends State<ToolbarToggleButtonWidget> {
  bool _hovered = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return TooltipWrapper(
      tooltip: TooltipWrapper.actionTooltip(widget.button.label,
          widget.button.description, widget.button.icon, widget.button.keybind),
      child: GestureDetector(
        onTap: widget.button.onPressed,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          cursor: SystemMouseCursors.click,
          child: Listener(
            onPointerDown: (_) => setState(() => _down = true),
            onPointerUp: (_) => setState(() => _down = false),
            child: Container(
              decoration: BoxDecoration(
                color:
                    widget.button.selected ? app().focusedSurfaceColor : null,
                borderRadius: BorderRadius.circular(2),
              ),
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
                    data:
                        IconThemeData(size: 16, color: app().primaryTextColor),
                    child: widget.button.icon),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
