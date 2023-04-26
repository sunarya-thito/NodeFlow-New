import 'package:flutter/material.dart';

List<Widget> joinWidgets(
    List<Widget> widgets, Widget Function() separatorBuilder) {
  final List<Widget> result = [];
  for (int i = 0; i < widgets.length; i++) {
    if (i > 0) {
      result.add(separatorBuilder());
    }
    result.add(widgets[i]);
  }
  return result;
}
