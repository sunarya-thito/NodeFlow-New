import 'package:flutter/material.dart';
import 'package:nodeflow/ui/compact_data.dart';

class DividerVertical extends StatelessWidget {
  const DividerVertical({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      color: CompactData.of(context).dividerColor,
      thickness: 1,
      width: 1,
    );
  }
}
