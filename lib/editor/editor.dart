import 'package:flutter/material.dart';
import 'package:nodeflow/action.dart';
import 'package:nodeflow/application.dart';
import 'package:nodeflow/i18n/internationalization.dart';
import 'package:nodeflow/ui/menubar/menu_bar.dart';
import 'package:nodeflow/ui/menubar/menu_bar_component.dart';
import 'package:nodeflow/ui/menubar/menu_bar_viewport.dart';
import 'package:nodeflow/ui/overlay/overlay_controller.dart';
import 'package:nodeflow/ui/split.dart';
import 'package:nodeflow/ui/toolbar/toolbar.dart';
import 'package:nodeflow/ui/toolbar/toolbar_viewport.dart';
import 'package:nodeflow/ui/tooltip/tooltip_viewport.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  List<Toolbar> get toolbars => nodeflow.getContext<ActionContext>().toolbars;
  List<Menu> get menus => nodeflow.getContext<ActionContext>().menus;

  @override
  void initState() {
    super.initState();
    nodeflow.getContext<ActionContext>().addListener(update);
  }

  @override
  void dispose() {
    nodeflow.getContext<ActionContext>().removeListener(update);
    super.dispose();
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TooltipViewport(
      overlayController: OverlayController.of(context),
      child: MenuBarViewport(
        overlayController: OverlayController.of(context),
        viewport: ToolbarViewport(
          overlayController: OverlayController.of(context),
          toolbars: toolbars,
          child: Container(
            child: Split(
              mode: SplitMode.absolute,
              a: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 100),
                child: Container(
                  color: Colors.red,
                ),
              ),
              b: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 100),
                child: Container(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
        menuBarComponent: MenuBarComponent(
          title: I18n.project_default_name.asTextWidget(),
          menuBar: menus,
        ),
      ),
    );
  }
}
