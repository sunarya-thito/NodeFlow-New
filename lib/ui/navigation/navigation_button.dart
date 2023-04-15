import 'package:flutter/material.dart';
import 'package:nodeflow/ui/compact_data.dart';

class NavigationButton extends StatefulWidget {
  final Widget icon;
  final Widget label;
  final Widget? badge;
  final void Function() onTap;
  final bool selected;
  const NavigationButton({
    Key? key,
    required this.icon,
    required this.label,
    this.badge,
    this.selected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  NavigationButtonState createState() => NavigationButtonState();
}

class NavigationButtonState extends State<NavigationButton> {
  bool hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          hovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          hovered = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: widget.selected ? app().selectedColor : null,
              // color: Colors.red,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: hovered && !widget.selected ? app().secondaryTextColor : Colors.transparent, width: 1),
            ),
            child: Row(
              children: [
                IconTheme(data: IconThemeData(size: 16, color: widget.selected ? app().selectedTextColor : app().primaryTextColor), child: widget.icon),
                SizedBox(
                  width: 18,
                ),
                Expanded(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: widget.selected ? app().selectedTextColor : app().primaryTextColor,
                    ),
                    child: widget.label,
                  ),
                ),
                if (widget.badge != null) widget.badge!,
              ],
            )),
      ),
    );
  }
}
