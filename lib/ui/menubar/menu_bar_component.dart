import 'package:flutter/material.dart';
import 'package:nodeflow/i18n/internationalization.dart';
import 'package:nodeflow/ui/compact_data.dart';
import 'package:nodeflow/ui/menubar/menu_bar.dart';
import 'package:nodeflow/ui/menubar/menu_bar_controller.dart';
import 'package:nodeflow/ui/menubar/menu_bar_data.dart';
import 'package:nodeflow/ui/menubar/menu_bar_item_component.dart';
import 'package:nodeflow/ui/menubar/menu_popup.dart';

class MenuBarComponent extends StatefulWidget {
  static double menuBarHeight = 24;
  final List<Menu> menuBar;
  final Widget? title;
  const MenuBarComponent({Key? key, required this.menuBar, this.title}) : super(key: key);

  @override
  _MenuBarComponentState createState() => _MenuBarComponentState();
}

class _MenuBarComponentState extends State<MenuBarComponent> {
  Menu? _hovered;
  Menu? _opened;

  MnemonicGroup _mnemonicGroup = MnemonicGroup();

  @override
  void initState() {
    super.initState();
    _mnemonicGroup.properties.addAll(widget.menuBar.map((e) => MnemonicProperty(e, -1)));
    _mnemonicGroup.recalculateMnemonic();
  }

  @override
  void didUpdateWidget(covariant MenuBarComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    _mnemonicGroup.properties.clear();
    _mnemonicGroup.properties.addAll(widget.menuBar.map((e) => MnemonicProperty(e, -1)));
    _mnemonicGroup.recalculateMnemonic();
  }

  @override
  void dispose() {
    _mnemonicGroup.properties.clear();
    super.dispose();
  }

  void update() {
    MenuBarController controller = MenuBarData.of(context).controller;
    if (_opened != null && !controller.isMenuShown(_opened!)) {
      _opened = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MenuBarData.of(context).controller,
      builder: (context, controller, child) {
        update();
        return Container(
          height: MenuBarComponent.menuBarHeight,
          color: app().surfaceColor,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.menuBar
                  .map((e) => MenuBarItemComponent(
                        menu: e,
                        controller: controller,
                        hovered: _hovered == e,
                        focused: controller.isMenuShown(e),
                        mnemonicGroup: _mnemonicGroup,
                        onHover: (hover, offset) {
                          if (e.isDisabled) return;
                          setState(() {
                            _hovered = hover ? e : null;
                            if (_opened != null && _opened != e) {
                              controller.removePopup(_opened!);
                              _opened = e;
                              controller.pushPopup(MenuPopup(menu: e, globalOffset: offset));
                            }
                          });
                        },
                        onTap: (offset) {
                          if (e.isDisabled) return;
                          setState(() {
                            if (_opened != null) {
                              controller.removePopup(_opened!);
                              if (_opened == e) {
                                _opened = null;
                                return;
                              }
                            }
                            _opened = e;
                            controller.pushPopup(MenuPopup(menu: e, globalOffset: offset));
                          });
                        },
                      ))
                  .toList(),
            ),
            SizedBox(
              width: 48,
            ),
            if (widget.title != null)
              Expanded(
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: app().secondaryTextColor,
                    fontSize: 12,
                  ),
                  child: widget.title!,
                ),
              ),
          ]),
        );
      },
    );
  }
}
