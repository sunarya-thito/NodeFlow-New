import 'package:flutter/material.dart';

enum OverlayLevel { toolbar, dialog, notification, tooltip }

class OverlayWidget {
  final OverlayLevel level;
  final Widget Function(BuildContext context) builder;

  OverlayWidget({required this.level, required this.builder});
}
