import 'package:flutter/material.dart';
import 'package:nodeflow/ui/compact_data.dart';

class DividerHorizontal extends StatelessWidget {
  const DividerHorizontal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: CompactData.of(context).dividerColor,
      height: 1,
      thickness: 1,
    );
  }
}
