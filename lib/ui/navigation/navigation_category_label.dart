import 'package:flutter/material.dart';
import 'package:nodeflow/i18n/internationalization.dart';
import 'package:nodeflow/ui/compact_data.dart';

class NavigationCategoryLabel extends StatelessWidget {
  final I18n label;
  const NavigationCategoryLabel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: app(context).secondaryTextColor, fontSize: 12, decoration: TextDecoration.none, fontWeight: FontWeight.normal),
      child: label.asTextWidget(),
    );
  }
}
