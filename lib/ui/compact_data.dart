import 'package:flutter/material.dart';

extension CompactDataStatelessAccessor on StatelessWidget {
  CompactData app(BuildContext context) {
    return CompactData.of(context);
  }
}

extension CompactDataStatefulAccessor on State {
  CompactData app() {
    return CompactData.of(context);
  }
}

class CompactData extends InheritedWidget {
  const CompactData({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  static CompactData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CompactData>()!;
  }

  Color get buttonHovered => rgbo(255, 255, 255, 0.1);
  Color get buttonDown => rgbo(255, 255, 255, 0.25);
  Color get cursorColor => rgb(255, 255, 255);
  Color get dividerColor => rgb(50, 50, 50);
  Color get searchBarColor => rgb(50, 50, 50);
  Color get hoveredSurfaceColor => rgb(50, 50, 50);
  Color get focusedSurfaceColor => rgb(46, 125, 169);
  Color get surfaceColor => rgb(30, 30, 30);
  Color get tooltipColor => rgb(40, 40, 40);
  Color get backgroundColor => rgb(20, 20, 20);
  Color get cardColor => rgb(50, 50, 50);
  Color get labelColor => rgb(120, 120, 120);
  Color get iconColor => rgb(255, 255, 255);
  Color get primaryTextColor => rgb(255, 255, 255);
  Color get secondaryTextColor => rgb(150, 150, 150);
  Color get selectedTextColor => rgb(20, 20, 20);
  Color get selectedColor => rgb(255, 255, 255);

  @override
  bool updateShouldNotify(covariant CompactData oldWidget) {
    return false;
  }

  static Color rgbo(int r, int g, int b, double opacity) {
    return Color.fromARGB((opacity * 255).toInt(), r, g, b);
  }

  static Color orgb(double opacity, int r, int g, int b) {
    return Color.fromARGB((opacity * 255).toInt(), r, g, b);
  }

  static Color rgb(int r, int g, int b) {
    return Color.fromARGB(255, r, g, b);
  }

  static Color argb(int a, int r, int g, int b) {
    return Color.fromARGB(a, r, g, b);
  }

  static Color solid(int color) {
    return Color(0xFF000000 + color);
  }

  static Color alpha(int color, double opacity) {
    return Color(0xFF000000 + color).withOpacity(opacity);
  }
}
