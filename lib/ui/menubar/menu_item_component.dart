import 'package:flutter/material.dart';
import 'package:nodeflow/hotkey.dart';
import 'package:nodeflow/i18n/internationalization.dart';
import 'package:nodeflow/ui/compact_data.dart';
import 'package:nodeflow/ui/menubar/menu_bar.dart';
import 'package:nodeflow/ui/menubar/menu_bar_controller.dart';

class MenuItemComponent extends StatefulWidget {
  final Menu menu;
  final MenuBarController controller;
  final bool hovered, focused;
  final Function(Offset) onTap;
  final Function(bool, Offset) onHover;
  final MnemonicGroup mnemonicGroup;
  final ShortcutKey? keybind;
  const MenuItemComponent({
    Key? key,
    required this.menu,
    required this.focused,
    required this.controller,
    required this.hovered,
    required this.onTap,
    required this.onHover,
    required this.mnemonicGroup,
    this.keybind,
  }) : super(key: key);

  @override
  _MenuItemComponentState createState() => _MenuItemComponentState();
}

class _MenuItemComponentState extends State<MenuItemComponent> {
  static const double iconSize = 16;
  Widget buildIconOrEmpty() {
    if (widget.menu.icon != null) {
      return IconTheme(
          data: IconThemeData(size: iconSize, color: widget.menu.isDisabled ? app().secondaryTextColor : app().primaryTextColor), child: widget.menu.icon!);
    } else {
      return const SizedBox(width: iconSize, height: iconSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.menu.onTap?.call();
        var rObj = context.findRenderObject();
        if (rObj is RenderBox) {
          var sizeOffset = Offset(rObj.size.width, -1);
          var offset = rObj.localToGlobal(sizeOffset);
          widget.onTap(offset);
        }
        // close other menus
      },
      child: MouseRegion(
        onEnter: (event) {
          var rObj = context.findRenderObject();
          if (rObj is RenderBox) {
            var sizeOffset = Offset(rObj.size.width, -1);
            var offset = rObj.localToGlobal(sizeOffset);
            widget.onHover(true, offset);
          }
        },
        onExit: (event) {
          var rObj = context.findRenderObject();
          if (rObj is RenderBox) {
            var sizeOffset = Offset(rObj.size.width, -1);
            var offset = rObj.localToGlobal(sizeOffset);
            widget.onHover(false, offset);
          }
        },
        child: Container(
          color: widget.focused
              ? app().focusedSurfaceColor
              : widget.hovered
                  ? app().hoveredSurfaceColor
                  : Colors.transparent,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: DefaultTextStyle(
            style: TextStyle(
              color: widget.menu.isDisabled ? app().secondaryTextColor : app().primaryTextColor,
              decorationColor: widget.menu.isDisabled ? app().secondaryTextColor : app().primaryTextColor,
              decorationThickness: 1,
              fontSize: 12,
            ),
            child: Row(
              children: [
                buildIconOrEmpty(),
                const SizedBox(width: 10),
                Expanded(
                  child: widget.menu.label.asMnemonicWidget(widget.mnemonicGroup.getMnemonicIndex(widget.menu)),
                ),
                const SizedBox(width: 16),
                if (widget.menu.closeOnClick && widget.keybind != null)
                  Text(
                    widget.keybind!.toString(),
                    style: TextStyle(
                      color: app().secondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
                if (!widget.menu.closeOnClick)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: widget.menu.isDisabled ? app().secondaryTextColor : app().primaryTextColor,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
