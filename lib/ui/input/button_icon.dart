import 'package:flutter/material.dart';
import 'package:nodeflow/ui/compact_data.dart';

class ButtonIcon extends StatelessWidget {
  final Widget icon;
  final Function()? onTap;
  final double? iconSize;
  const ButtonIcon({Key? key, required this.icon, this.onTap, this.iconSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: iconSize,
      onPressed: onTap,
      icon: icon,
      iconSize: iconSize,
      color: app(context).secondaryTextColor,
      disabledColor: app(context).secondaryTextColor,
    );
  }
}
