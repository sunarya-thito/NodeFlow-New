import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nodeflow/i18n/internationalization.dart';
import 'package:nodeflow/ui/compact_data.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Material(
        color: app().searchBarColor,
        borderRadius: BorderRadius.circular(500),
        child: I18n.dashboard_search.asBuilderWidget((context, i18n) {
          return TextField(
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              isDense: true,
              suffixIcon: const Icon(CupertinoIcons.search),
              border: InputBorder.none,
              suffixIconColor: app().secondaryTextColor,
              hintText: i18n.message,
              hintStyle: TextStyle(
                color: CompactData.of(context).secondaryTextColor,
              ),
            ),
            style: TextStyle(color: CompactData.of(context).primaryTextColor, fontSize: 16),
            cursorColor: CompactData.of(context).cursorColor,
            cursorWidth: 1.2,
          );
        }),
      ),
    );
  }
}
