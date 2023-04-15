import 'package:flutter/material.dart';
import 'package:nodeflow/ui/compact_data.dart';

class CompactUI extends StatefulWidget {
  final Widget child;
  const CompactUI({Key? key, required this.child}) : super(key: key);

  @override
  _CompactUIState createState() => _CompactUIState();
}

class _CompactUIState extends State<CompactUI> {
  @override
  Widget build(BuildContext context) {
    return CompactData(child: Builder(builder: (context) {
      return Container(
        color: CompactData.of(context).backgroundColor,
        child: widget.child,
      );
    }));
  }
}
