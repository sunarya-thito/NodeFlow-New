import 'package:flutter/material.dart';
import 'package:nodeflow/ui/toolbar/toolbar.dart';

class ToolbarViewport extends StatefulWidget {
  final List<Toolbar> toolbars;
  const ToolbarViewport({Key? key, required this.toolbars}) : super(key: key);

  @override
  _ToolbarViewportState createState() => _ToolbarViewportState();
}

class _ToolbarViewportState extends State<ToolbarViewport> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Column(children: []));
  }
}
