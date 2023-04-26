import 'package:flutter/material.dart';

class TooltipController extends ChangeNotifier {
  Widget Function(BuildContext)? _tooltip;
  Offset? _position;
  void preserveTooltip(Widget Function(BuildContext) builder) {
    _tooltip = builder;
    notifyListeners();
  }

  void updatePosition(Offset position) {
    _position = position;
    notifyListeners();
  }

  void clear() {
    _tooltip = null;
    _position = null;
    notifyListeners();
  }

  Widget buildTooltip(BuildContext context) {
    return _tooltip!(context);
  }

  Offset get position => _position!;

  bool get hasTooltip => _tooltip != null;
  bool get isShowing => hasTooltip && _position != null;
}
