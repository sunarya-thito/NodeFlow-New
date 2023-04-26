import 'package:flutter/material.dart';
import 'package:nodeflow/hotkey.dart';
import 'package:nodeflow/i18n/internationalization.dart';
import 'package:nodeflow/ui/compact_data.dart';
import 'package:nodeflow/ui/tooltip/tooltip_viewport.dart';

class TooltipWrapper extends StatefulWidget {
  // predefined tooltip styles
  static Widget Function(BuildContext) defaultTooltip(I18n label) {
    return (context) {
      return Container(
        padding: const EdgeInsets.all(8),
        child: DefaultTextStyle(
          style: TextStyle(
              color: CompactData.of(context).primaryTextColor, fontSize: 12),
          child: label.asTextWidget(),
        ),
      );
    };
  }

  static Widget Function(BuildContext) descriptiveTooltip(
      I18n label, I18n description) {
    return (context) {
      return Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultTextStyle(
                style: TextStyle(
                    color: CompactData.of(context).primaryTextColor,
                    fontSize: 12),
                child: label.asTextWidget(),
              ),
              const SizedBox(height: 4),
              DefaultTextStyle(
                style: TextStyle(
                    color: CompactData.of(context).secondaryTextColor,
                    fontSize: 12),
                child: description.asTextWidget(),
              ),
            ],
          ));
    };
  }

  static Widget Function(BuildContext) actionTooltip(
      I18n label, I18n? description, Widget? icon, ShortcutKey? keybind) {
    return (context) {
      return Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              if (icon != null)
                IconTheme(
                  data: IconThemeData(
                      size: 18,
                      color: CompactData.of(context).primaryTextColor),
                  child: icon,
                ),
              if (icon != null) const SizedBox(width: 8),
              IntrinsicWidth(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DefaultTextStyle(
                          style: TextStyle(
                              color: CompactData.of(context).primaryTextColor,
                              fontSize: 12),
                          child: label.asTextWidget(),
                        ),
                      ),
                      if (keybind != null) const SizedBox(width: 32),
                      if (keybind != null)
                        Text(keybind.toString(),
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                color:
                                    CompactData.of(context).secondaryTextColor,
                                fontSize: 12)),
                    ],
                  ),
                  if (description != null) const SizedBox(height: 4),
                  if (description != null)
                    DefaultTextStyle(
                      style: TextStyle(
                          color: CompactData.of(context).secondaryTextColor,
                          fontSize: 12),
                      child: description.asTextWidget(),
                    ),
                ],
              )),
            ],
          ));
    };
  }

  final Widget Function(BuildContext context) tooltip;
  final Widget child;
  const TooltipWrapper({Key? key, required this.child, required this.tooltip})
      : super(key: key);

  @override
  _TooltipWrapperState createState() => _TooltipWrapperState();
}

class _TooltipWrapperState extends State<TooltipWrapper> {
  static const int _tooltipDelay = 500;
  bool _hovered = false;
  bool _shown = false;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      onFocusChange: (focused) {
        if (_shown) {
          _shown = false;
          TooltipData.of(context).controller.clear();
        }
      },
      child: MouseRegion(
        onEnter: (event) {
          _hovered = true;
          if (_focusNode.hasFocus) return;
          // wait for few milliseconds before showing tooltip
          Future.delayed(const Duration(milliseconds: _tooltipDelay), () {
            if (mounted && _hovered) {
              _shown = true;
              TooltipData.of(context)
                  .controller
                  .preserveTooltip(widget.tooltip);
            }
          });
        },
        onHover: (event) {
          if (_hovered) {
            TooltipData.of(context).controller.updatePosition(event.position);
          }
        },
        onExit: (event) {
          _hovered = false;
          if (_shown) {
            // is this even necessary?
            TooltipData.of(context).controller.clear();
            _shown = false;
          }
        },
        child: widget.child,
      ),
    );
  }
}
