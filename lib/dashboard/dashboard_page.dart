import 'package:flutter/material.dart';
import 'package:nodeflow/i18n/internationalization.dart';

class DashboardCategory {
  final I18n label;
  final List<DashboardPage> pages;

  DashboardCategory({required this.label, required this.pages});
}

class DashboardPage {
  final Icon icon;
  final I18n label;
  final Widget Function(BuildContext context)? pageBuilder;
  final void Function()? onTap;

  DashboardPage({required this.icon, required this.label, this.pageBuilder, this.onTap});
}
