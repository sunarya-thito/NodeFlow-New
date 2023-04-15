import 'package:flutter/material.dart';
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
  const MenuItemComponent({
    Key? key,
    required this.menu,
    required this.focused,
    required this.controller,
    required this.hovered,
    required this.onTap,
    required this.onHover,
    required this.mnemonicGroup,
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
        if (widget.menu is MenuButton) {
          (widget.menu as MenuButton).onTap?.call();
        }
        var rObj = context.findRenderObject();
        if (rObj is RenderBox) {
          var offset = rObj.localToGlobal(Offset.zero);
          // adds width
          offset += Offset(rObj.size.width, -1); // -1 because of the border
          widget.onTap(offset);
        }
        // close other menus
      },
      child: MouseRegion(
        onEnter: (event) {
          var rObj = context.findRenderObject();
          if (rObj is RenderBox) {
            var offset = rObj.localToGlobal(Offset.zero);
            // adds width
            offset += Offset(rObj.size.width, -1);
            widget.onHover(true, offset);
          }
        },
        onExit: (event) {
          var rObj = context.findRenderObject();
          if (rObj is RenderBox) {
            var offset = rObj.localToGlobal(Offset.zero);
            // add width
            offset += Offset(rObj.size.width, -1);
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
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          width: 180,
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
                const SizedBox(width: 4),
                Expanded(
                  child: widget.menu.label.asMnemonicWidget(widget.mnemonicGroup.getMnemonicIndex(widget.menu)),
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
