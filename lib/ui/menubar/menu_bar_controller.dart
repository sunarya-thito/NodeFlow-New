import 'package:flutter/foundation.dart';
import 'package:nodeflow/ui/menubar/menu_bar.dart';
import 'package:nodeflow/ui/menubar/menu_popup.dart';

class MenuBarController extends ValueListenable<MenuBarController>
    with ChangeNotifier {
  final List<MenuPopupWidget> _shownPopup = [];

  // unmodifiable list of shown popups
  List<MenuPopupWidget> get shownPopup => List.unmodifiable(_shownPopup);

  Menu? hovered;

  @override
  void dispose() {
    super.dispose();
  }

  bool isMenuShown(Menu menu) {
    if (_shownPopup.any((element) => element.menu == menu)) return true;
    // check if any of the submenus is shown
    for (var item in menu.items) {
      if (isMenuShown(item)) return true;
    }
    return false;
  }

  void closeAll() {
    _shownPopup.clear();
    notifyListeners();
  }

  bool _hasChildren(Menu a, Menu b) {
    // check if a has no b as its children
    for (var item in a.items) {
      if (item == b) return false;
      if (!_hasChildren(item, b)) return false;
    }
    return true;
  }

  void pushPopup(MenuPopupWidget popup) {
    for (var i = 0; i < _shownPopup.length; i++) {
      if (_shownPopup[i].menu == popup.menu) {
        _shownPopup.removeAt(i);
        break;
      }
    }
    // remove sibling popups
    for (MenuPopupWidget p in _shownPopup) {
      if (_hasChildren(p.menu, popup.menu) &&
          _hasChildren(popup.menu, p.menu)) {
        _shownPopup.remove(p);
      }
    }
    removeChildPopups(popup.menu);
    if (popup.menu.items.isNotEmpty) {
      _shownPopup.add(popup);
    }
    notifyListeners();
  }

  void removeChildPopups(Menu menu) {
    for (var item in menu.items) {
      _removePopupWithChildren(item, null);
    }
    notifyListeners();
  }

  void removePopup(Menu popup,
      {bool withChildren = true, bool Function(Menu)? filter}) {
    if (withChildren) {
      _removePopupWithChildren(popup, filter);
    } else {
      _shownPopup.removeWhere((element) => element.menu == popup);
    }
    notifyListeners();
  }

  void _removePopupWithChildren(Menu popup, bool Function(Menu)? filter) {
    if (filter != null && !filter(popup)) return;
    _shownPopup.removeWhere((e) => e.menu == popup);
    // remove all popups that are children of this popup
    for (Menu menu in popup.items) {
      _removePopupWithChildren(menu, filter);
    }
  }

  // this is ugly
  @override
  MenuBarController get value => this;
}
