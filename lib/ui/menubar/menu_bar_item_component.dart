import 'package:flutter/material.dart';
import 'package:nodeflow/i18n/internationalization.dart';
import 'package:nodeflow/ui/compact_data.dart';
import 'package:nodeflow/ui/menubar/menu_bar.dart';
import 'package:nodeflow/ui/menubar/menu_bar_controller.dart';
import 'package:nodeflow/ui/menubar/menu_item_component.dart';

/// Button that shows up on the menu bar for Menu.
/// For Sub-Menu, see [MenuItemComponent].
class MenuBarItemComponent extends StatefulWidget {
  final Menu menu;
  final MenuBarController controller;
  final bool hovered, focused;
  final Function(Offset) onTap;
  final Function(bool, Offset) onHover;
  final MnemonicGroup mnemonicGroup;
  const MenuBarItemComponent({
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
  _MenuBarItemComponentState createState() => _MenuBarItemComponentState();
}

class _MenuBarItemComponentState extends State<MenuBarItemComponent> {
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
          // adds height
          offset += Offset(0, rObj.size.height);
          widget.onTap(offset);
        }
        // close other menus
      },
      child: MouseRegion(
        onEnter: (event) {
          var rObj = context.findRenderObject();
          if (rObj is RenderBox) {
            var offset = rObj.localToGlobal(Offset.zero);
            // adds height
            offset += Offset(0, rObj.size.height);
            widget.onHover(true, offset);
          }
        },
        onExit: (event) {
          var rObj = context.findRenderObject();
          if (rObj is RenderBox) {
            var offset = rObj.localToGlobal(Offset.zero);
            offset += Offset(0, rObj.size.height);
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
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: DefaultTextStyle(
            style: TextStyle(
              color: widget.menu.isDisabled ? app().secondaryTextColor : app().primaryTextColor,
              decorationColor: widget.menu.isDisabled ? app().secondaryTextColor : app().primaryTextColor,
              decorationThickness: 1,
              fontSize: 12,
            ),
            child: widget.menu.label.asMnemonicWidget(widget.mnemonicGroup.getMnemonicIndex(widget.menu)),
          ),
        ),
      ),
    );
  }
}
