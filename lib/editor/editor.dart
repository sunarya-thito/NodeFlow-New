import 'package:flutter/material.dart';
import 'package:nodeflow/i18n/internationalization.dart';
import 'package:nodeflow/ui/menubar/menu_bar.dart';
import 'package:nodeflow/ui/menubar/menu_bar_component.dart';
import 'package:nodeflow/ui/menubar/menu_bar_viewport.dart';
import 'package:nodeflow/ui/split.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  @override
  Widget build(BuildContext context) {
    return MenuBarViewport(
      viewport: Container(
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
      menuBarComponent: MenuBarComponent(
        title: I18n.project_default_name.asTextWidget(),
        menuBar: [
          Menu(label: I18n.menubar_file, items: [
            Menu(label: I18n.menubar_help, icon: Icon(Icons.account_circle), items: [
              Menu(label: I18n.menubar_help, icon: Icon(Icons.account_circle), items: [
                Menu(label: I18n.menubar_help, icon: Icon(Icons.account_circle), items: []),
              ]),
              Menu(label: I18n.menubar_help, icon: Icon(Icons.account_circle), items: []),
              Menu(label: I18n.menubar_edit, items: [
                MenuButton(label: I18n.menubar_help, icon: Icon(Icons.account_circle), onTap: () {}),
                MenuButton(label: I18n.menubar_help, icon: Icon(Icons.account_circle), onTap: () {}),
                MenuButton(label: I18n.menubar_help, icon: Icon(Icons.account_circle), onTap: () {}),
              ])
            ]),
          ]),
          Menu(label: I18n.menubar_edit, items: [
            MenuButton(label: I18n.menubar_help, icon: Icon(Icons.account_circle), onTap: () {}),
            MenuButton(label: I18n.menubar_help, icon: Icon(Icons.account_circle), onTap: () {}),
            MenuButton(label: I18n.menubar_help, icon: Icon(Icons.account_circle), onTap: () {}),
          ]),
          Menu(label: I18n.menubar_tools, items: []),
          Menu(label: I18n.menubar_view, items: []),
          Menu(label: I18n.menubar_help, items: []),
        ],
      ),
    );
  }
}
