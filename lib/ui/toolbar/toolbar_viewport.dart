import 'package:flutter/material.dart';
import 'package:nodeflow/i18n/internationalization_keys.dart';
import 'package:nodeflow/ui/compact_data.dart';
import 'package:nodeflow/ui/divider_horizontal.dart';
import 'package:nodeflow/ui/divider_vertical.dart';
import 'package:nodeflow/ui/input/search_bar.dart';
import 'package:nodeflow/ui/overlay/overlay_controller.dart';
import 'package:nodeflow/ui/toolbar/toolbar.dart';
import 'package:nodeflow/ui/toolbar/toolbar_overlay.dart';
import 'package:nodeflow/ui/tooltip/tooltip_wrapper.dart';
import 'package:nodeflow/ui/ui_util.dart';

class ToolbarData extends InheritedWidget {
  final ToolbarController controller;
  const ToolbarData({Key? key, required this.controller, required Widget child}) : super(key: key, child: child);

  static ToolbarData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ToolbarData>()!;
  }

  @override
  bool updateShouldNotify(covariant ToolbarData oldWidget) {
    return oldWidget.controller != controller;
  }
}

class ToolbarViewport extends StatefulWidget {
  final OverlayController overlayController;
  final List<Toolbar> toolbars;
  final Widget child;
  const ToolbarViewport({Key? key, required this.toolbars, required this.child, required this.overlayController}) : super(key: key);

  @override
  ToolbarViewportState createState() => ToolbarViewportState();
}

class ToolbarViewportState extends State<ToolbarViewport> {
  static const double toolbarHeight = 32;

  ToolbarController controller = ToolbarController();

  late ToolbarOverlay toolbarOverlay;

  @override
  void initState() {
    super.initState();
    toolbarOverlay = ToolbarOverlay(controller: controller);
    widget.overlayController.toolbar.add(toolbarOverlay);
  }

  @override
  void didUpdateWidget(covariant ToolbarViewport oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.overlayController != widget.overlayController) {
      widget.overlayController.toolbar.remove(toolbarOverlay);
      widget.overlayController.toolbar.add(toolbarOverlay);
    }
  }

  @override
  void dispose() {
    widget.overlayController.toolbar.remove(toolbarOverlay);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ToolbarData(
        controller: controller,
        child: Column(
          children: [
            Container(
              height: toolbarHeight,
              color: app().surfaceColor,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  ...joinWidgets(
                    widget.toolbars
                        .where((element) => element.hasItems)
                        .map((e) => ToolbarItemsViewport(items: e.items.where((element) => !element.hidden).toList()))
                        .toList(),
                    () => const DividerVertical(),
                  ),
                  const SizedBox(width: 8),
                  TooltipWrapper(
                    tooltip: TooltipWrapper.descriptiveTooltip(I18n.quickaccess_search, I18n.tooltip_quickaccess_search),
                    child: const SearchBar(),
                  ),
                ]),
              ),
            ),
            const DividerHorizontal(),
            Expanded(child: widget.child),
          ],
        ));
  }
}

class ToolbarItemsViewport extends StatefulWidget {
  final List<ToolbarItem> items;
  const ToolbarItemsViewport({Key? key, required this.items}) : super(key: key);

  @override
  _ToolbarItemsViewportState createState() => _ToolbarItemsViewportState();
}

class _ToolbarItemsViewportState extends State<ToolbarItemsViewport> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(children: widget.items.map((e) => Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: e.build(context))).toList()));
  }
}
