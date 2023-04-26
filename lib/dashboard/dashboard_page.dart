import 'package:flutter/material.dart';

import '../i18n/internationalization.dart';

class DashboardCategory {
  final Intl label;
  final List<DashboardPage> pages;

  DashboardCategory({required this.label, required this.pages});
}

class DashboardPage {
  final Icon icon;
  final Intl label;
  final Widget Function(BuildContext context)? pageBuilder;
  final void Function()? onTap;

  DashboardPage({required this.icon, required this.label, this.pageBuilder, this.onTap});
}
