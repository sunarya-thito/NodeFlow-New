import 'package:flutter/material.dart';
import 'package:nodeflow/ui/compact_data.dart';
import 'package:nodeflow/ui/custom_control.dart';
import 'package:nodeflow/ui/toolbar/toolbar.dart';
import 'package:nodeflow/ui/tooltip/tooltip_wrapper.dart';

class ToolbarButtonWidget extends StatefulWidget {
  final ToolbarButton button;
  const ToolbarButtonWidget({Key? key, required this.button}) : super(key: key);

  @override
  _ToolbarButtonWidgetState createState() => _ToolbarButtonWidgetState();
}

class _ToolbarButtonWidgetState extends State<ToolbarButtonWidget> {
  // final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TooltipWrapper(
      tooltip: TooltipWrapper.actionTooltip(widget.button.label, widget.button.description, widget.button.icon, widget.button.keybind),
      child: CustomControl(
        onTap: widget.button.onPressed,
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: state == ControlState.down
                  ? app().buttonDown
                  : state == ControlState.hovered
                      ? app().buttonHovered
                      : null,
              borderRadius: BorderRadius.circular(2),
            ),
            child: IconTheme(data: IconThemeData(size: 16, color: app().primaryTextColor), child: widget.button.icon),
          );
        },
      ),
    );
  }
}
