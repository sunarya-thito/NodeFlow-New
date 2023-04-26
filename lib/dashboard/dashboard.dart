import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nodeflow/i18n/internationalization_keys.dart';
import 'package:nodeflow/ui/divider_horizontal.dart';
import 'package:nodeflow/ui/divider_vertical.dart';
import 'package:nodeflow/ui/input/button_icon.dart';
import 'package:nodeflow/ui/input/search_bar.dart';
import 'package:nodeflow/ui/navigation/navigation_button.dart';
import 'package:nodeflow/ui/navigation/navigation_category.dart';
import 'package:nodeflow/ui/navigation/navigation_category_label.dart';
import 'package:nodeflow/ui/navigation/navigation_label.dart';
import 'package:nodeflow/ui/navigation/navigation_top_bar.dart';
import 'package:nodeflow/ui/ui_util.dart';

import '../ui/navigation/navigation_side_bar.dart';
import 'dashboard_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late DashboardPage selectedPage;

  late List<DashboardCategory> categories;

  @override
  void initState() {
    super.initState();
    categories = [
      DashboardCategory(
        label: I18n.dashboard_project,
        pages: [
          DashboardPage(
            icon: Icon(CupertinoIcons.house_fill),
            label: I18n.dashboard_project_overview,
            pageBuilder: (context) {
              return Container();
            },
          ),
          DashboardPage(
            icon: Icon(CupertinoIcons.archivebox_fill),
            label: I18n.dashboard_project_projects,
            pageBuilder: (context) {
              return Container();
            },
          ),
        ],
      ),
      DashboardCategory(
        label: I18n.dashboard_account,
        pages: [
          DashboardPage(
            icon: Icon(CupertinoIcons.money_dollar_circle),
            label: I18n.dashboard_account_billing,
            pageBuilder: (context) {
              return Container();
            },
          ),
          DashboardPage(
            icon: Icon(Icons.settings),
            label: I18n.dashboard_account_settings,
            pageBuilder: (context) {
              return Container();
            },
          ),
          DashboardPage(
            icon: Icon(Icons.logout),
            label: I18n.dashboard_account_logout,
            onTap: () {},
          )
        ],
      )
    ];
    selectedPage = categories[0].pages[0];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationSideBar(
          children: joinWidgets(
              categories.map((e) {
                return NavigationCategory(
                  label: NavigationCategoryLabel(
                    label: e.label,
                  ),
                  children: e.pages.map((p) {
                    return NavigationButton(
                      icon: p.icon,
                      label: NavigationLabel(
                        label: p.label,
                      ),
                      selected: selectedPage == p,
                      onTap: () {
                        setState(() {
                          selectedPage = p;
                          if (p.onTap != null) {
                            p.onTap!();
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              }).toList(),
              () => DividerHorizontal()),
        ),
        DividerVertical(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NavigationTopBar(
                children: [
                  SearchBar(),
                  Spacer(),
                  ButtonIcon(
                    icon: Icon(CupertinoIcons.bell_fill),
                    onTap: () {},
                    iconSize: 18,
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  DividerVertical(),
                ],
              ),
              DividerHorizontal(),
              Expanded(
                child: Container(
                  child: selectedPage.pageBuilder != null ? selectedPage.pageBuilder!(context) : Container(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
