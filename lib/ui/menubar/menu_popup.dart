import 'package:flutter/material.dart';
import 'package:nodeflow/i18n/internationalization.dart';
import 'package:nodeflow/ui/compact_data.dart';
import 'package:nodeflow/ui/menubar/menu_bar.dart';
import 'package:nodeflow/ui/menubar/menu_bar_data.dart';
import 'package:nodeflow/ui/menubar/menu_item_component.dart';

class MenuPopup extends StatefulWidget {
  final Menu menu;
  final Offset globalOffset;
  const MenuPopup({Key? key, required this.menu, required this.globalOffset}) : super(key: key);

  @override
  _MenuPopupState createState() => _MenuPopupState();
}

class _MenuPopupState extends State<MenuPopup> {
  MnemonicGroup _mnemonicGroup = MnemonicGroup();

  @override
  void initState() {
    super.initState();
    if (widget.menu.items != null) {
      _mnemonicGroup.properties.addAll(widget.menu.items!.map((e) => MnemonicProperty(e, -1)));
      _mnemonicGroup.recalculateMnemonic();
    }
  }

  @override
  void didUpdateWidget(covariant MenuPopup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.menu.items != null) {
      _mnemonicGroup.properties.clear();
      _mnemonicGroup.properties.addAll(widget.menu.items!.map((e) => MnemonicProperty(e, -1)));
      _mnemonicGroup.recalculateMnemonic();
    }
  }

  @override
  void dispose() {
    _mnemonicGroup.properties.clear();
    super.dispose();
  }

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MenuBarData.of(context).controller,
      builder: (context, controller, child) {
        return Container(
          decoration: BoxDecoration(
            color: app().surfaceColor,
            border: Border.all(color: app().dividerColor, width: 1),
          ),
          child: Column(
            children: widget.menu.items
                    ?.map(
                      (e) => MenuItemComponent(
                        menu: e,
                        hovered: controller.hovered == e,
                        focused: controller.hovered == e || controller.isMenuShown(e),
                        mnemonicGroup: _mnemonicGroup,
                        onHover: (hover, offset) {
                          if (e.isDisabled) return;
                          setState(() {
                            if (hover) {
                              controller.hovered = e;
                              controller.pushPopup(MenuPopup(menu: e, globalOffset: offset));
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
                          // if (e.isDisabled) return;
                          // setState(() {
                          //   if (_opened != null) {
                          //     if (_opened == e) {
                          //       _opened = null;
                          //       return;
                          //     }
                          //   } else {
                          //     _opened = e;
                          //     controller.pushPopup(MenuPopup(menu: e, globalOffset: offset));
                          //   }
                          // });
                        },
                        controller: controller,
                      ),
                    )
                    .toList() ??
                [],
          ),
        );
      },
    );
  }
}
