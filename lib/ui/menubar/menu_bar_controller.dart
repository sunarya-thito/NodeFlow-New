import 'package:flutter/foundation.dart';
import 'package:nodeflow/ui/menubar/menu_bar.dart';
import 'package:nodeflow/ui/menubar/menu_popup.dart';

class MenuBarController extends ValueListenable<MenuBarController> with ChangeNotifier {
  List<MenuPopup> _shownPopup = [];

  // unmodifiable list of shown popups
  List<MenuPopup> get shownPopup => List.unmodifiable(_shownPopup);

  Menu? hovered;

  bool isMenuShown(Menu menu) {
    if (_shownPopup.any((element) => element.menu == menu)) return true;
    // check if any of the submenus is shown
    if (menu.items != null) {
      for (var item in menu.items!) {
        if (isMenuShown(item)) return true;
      }
    }
    return false;
  }

  void closeAll() {
    _shownPopup.clear();
    notifyListeners();
  }

  bool _hasChildren(Menu a, Menu b) {
    // check if a has no b as its children
    if (a.items != null) {
      for (var item in a.items!) {
        if (item == b) return false;
        if (!_hasChildren(item, b)) return false;
      }
    }
    return true;
  }

  void pushPopup(MenuPopup popup) {
    for (var i = 0; i < _shownPopup.length; i++) {
      if (_shownPopup[i].menu == popup.menu) {
        _shownPopup.removeAt(i);
        break;
      }
    }
    // remove sibling popups
    for (MenuPopup p in _shownPopup) {
      if (_hasChildren(p.menu, popup.menu) && _hasChildren(popup.menu, p.menu)) {
        _shownPopup.remove(p);
      }
    }
    removeChildPopups(popup.menu);
    if (popup.menu.items != null && popup.menu.items!.isNotEmpty) {
      _shownPopup.add(popup);
    }
    notifyListeners();
  }

  void removeChildPopups(Menu menu) {
    if (menu.items != null) {
      for (var item in menu.items!) {
        _removePopupWithChildren(item, null);
      }
    }
    notifyListeners();
  }

  void removePopup(Menu popup, {bool withChildren = true, bool Function(Menu)? filter}) {
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
    if (popup.items != null) {
      for (Menu menu in popup.items!) {
        _removePopupWithChildren(menu, filter);
      }
    }
  }

  // this is ugly
  @override
  MenuBarController get value => this;
}
