import 'package:flutter/material.dart';
import 'package:nodeflow/i18n/internationalization.dart';
import 'package:nodeflow/ui/compact_data.dart';
import 'package:nodeflow/ui/menubar/menu_bar.dart';
import 'package:nodeflow/ui/menubar/menu_bar_controller.dart';
import 'package:nodeflow/ui/menubar/menu_item_component.dart';

class MenuPopupWidget extends StatefulWidget {
  final MenuBarController controller;
  final Menu menu;
  final Offset globalOffset;
  const MenuPopupWidget(
      {Key? key,
      required this.menu,
      required this.globalOffset,
      required this.controller})
      : super(key: key);

  @override
  _MenuPopupWidgetState createState() => _MenuPopupWidgetState();
}

class _MenuPopupWidgetState extends State<MenuPopupWidget> {
  MnemonicGroup _mnemonicGroup = MnemonicGroup();

  @override
  void initState() {
    super.initState();
    _mnemonicGroup.properties
        .addAll(widget.menu.items.map((e) => MnemonicProperty(e, -1)));
    _mnemonicGroup.recalculateMnemonic();

    widget.controller.addListener(update);
  }

  void update() {
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant MenuPopupWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _mnemonicGroup.properties.clear();
    _mnemonicGroup.properties
        .addAll(widget.menu.items.map((e) => MnemonicProperty(e, -1)));
    _mnemonicGroup.recalculateMnemonic();

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(update);
      widget.controller.addListener(update);
    }
  }

  @override
  void dispose() {
    _mnemonicGroup.properties.clear();
    widget.controller.removeListener(update);
    super.dispose();
  }

  MenuBarController get controller => widget.controller;

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      child: Container(
        decoration: BoxDecoration(
          color: app().surfaceColor,
          border: Border.all(color: app().dividerColor, width: 1),
        ),
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.menu.items
                .where((element) => !element.hidden)
                .map(
                  (e) => MenuItemComponent(
                    menu: e,
                    hovered: controller.hovered == e,
                    focused:
                        controller.hovered == e || controller.isMenuShown(e),
                    mnemonicGroup: _mnemonicGroup,
                    keybind: e.keybind,
                    onHover: (hover, offset) {
                      if (e.isDisabled) return;
                      setState(() {
                        if (hover) {
                          controller.hovered = e;
                          controller.pushPopup(MenuPopupWidget(
                            menu: e,
                            globalOffset: offset,
                            controller: widget.controller,
                          ));
                        } else if (controller.hovered == e) {
                          controller.hovered = null;
                        }
                      });
                    },
                    onTap: (offset) {
                      if (e.isDisabled) return;
                      if (e.closeOnClick) {
                        // close current popup
                        controller.closeAll();
                      }
                    },
                    controller: controller,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
