import 'package:flutter/material.dart';
import 'package:nodeflow/ui/overlay/overlay_data.dart';

class OverlayController extends ChangeNotifier {
  final OverlayLayer toolbar = OverlayLayer();
  final OverlayLayer menubar = OverlayLayer();
  final OverlayLayer contextmenu = OverlayLayer();
  final OverlayLayer tooltip = OverlayLayer();
  final OverlayLayer modal = OverlayLayer(); // dialog, alert, confirm, etc.
  final OverlayLayer overlay = OverlayLayer();
  static OverlayController of(BuildContext context) {
    return OverlayData.of(context).viewport.widget.controller;
  }

  final List<OverlayLayer> _layers = [];

  OverlayController() {
    _layers.add(toolbar);
    _layers.add(menubar);
    _layers.add(contextmenu);
    _layers.add(tooltip);
    _layers.add(modal);
    _layers.add(overlay);
  }

  List<OverlayLayer> get layers => List.unmodifiable(_layers);

  void addLayer(OverlayLayer layer) {
    _layers.add(layer);
    notifyListeners();
  }

  void removeLayer(OverlayLayer layer) {
    _layers.remove(layer);
    notifyListeners();
  }

  void addLayerAt(OverlayLayer layer, int index) {
    _layers.insert(index, layer);
    notifyListeners();
  }

  void removeLayerAt(int index) {
    _layers.removeAt(index);
    notifyListeners();
  }
}

class OverlayLayer extends ChangeNotifier {
  List<Widget> _children = [];

  List<Widget> get children => List.unmodifiable(_children);

  void add(Widget child) {
    _children.add(child);
    notifyListeners();
  }

  void clear() {
    _children.clear();
    notifyListeners();
  }

  void remove(Widget child) {
    _children.remove(child);
    notifyListeners();
  }
}
