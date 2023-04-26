import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nodeflow/assets/asset_manager.dart';
import 'package:nodeflow/ui/menubar/menu_bar.dart';

Map<String, Intl> _messages = {};

Future<void> reloadMessages(String assetName) async {
  _messages.clear();
  String string = await assets.loadTextAsset(assetName);
  // parse string to json
  // the json map could contain another json map
  // it needs to be flattened
  // the flattened map should be added to _messages
  Map map = jsonDecode(string);
  map = flatten(map);
  // convert the map to a list of I18n objects
  map.forEach((key, value) {
    Intl? old = _messages[key];
    if (old != null) {
      old.message = value;
    } else {
      _messages[key] = Intl(value);
    }
    if (kDebugMode) {
      print('Loaded message: $key = $value');
    }
  });
  if (kDebugMode) {
    print('Loaded ${_messages.length} messages');
  }
}

Map flatten(Map map) {
  Map result = {};
  map.forEach((key, value) {
    if (value is Map) {
      Map flattened = flatten(value);
      flattened.forEach((key2, value2) {
        result[key + '.' + key2] = value2;
      });
    } else {
      result[key] = value;
    }
  });
  return result;
}

class Intl extends ChangeNotifier {
  static Intl get(String key) {
    Intl? result = _messages[key];
    if (result == null) {
      if (kDebugMode) {
        print('Message not found: $key');
        print('Available messages:');
        _messages.forEach((key, value) {
          print('  $key = ${value.message}');
        });
      }
      throw Exception('Message not found: $key');
    }
    return result;
  }

  String _message;

  Intl(this._message);

  String get message => _message;
  set message(String message) {
    _message = message;
    notifyListeners();
  }

  Widget asTextWidget() {
    return I18nTextWidget(i18n: this);
  }

  Widget asBuilderWidget(Widget Function(BuildContext context, Intl i18n) builder) {
    return I18nBuilderWidget(i18n: this, builder: builder);
  }

  Widget asMnemonicWidget(int index) {
    return I18nMnemonicWidget(i18n: this, index: index);
  }
}

class MnemonicGroup {
  static const bool enableMnemonic = false;
  static bool canBeUsedAsMnemonic(String char) {
    return
        // A - Z
        (char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 90) ||
            // a - z
            (char.codeUnitAt(0) >= 97 && char.codeUnitAt(0) <= 122);
  }

  List<MnemonicProperty> properties = [];
  void remove(Menu label) {
    properties.removeWhere((element) => element.text == label);
    recalculateMnemonic();
  }

  void add(Menu label) {
    properties.add(MnemonicProperty(label, -1));
    recalculateMnemonic();
  }

  int getMnemonicIndex(Menu menu) {
    if (!enableMnemonic) {
      return -1;
    }
    for (MnemonicProperty property in properties) {
      if (property.text == menu) {
        return property.index;
      }
    }
    return -1;
  }

  void recalculateMnemonic() {
    Set<String> usedCharacters = {};
    for (var m in properties) {
      var msg = m.text.label.message;
      for (int i = 0; i < msg.length; i++) {
        var c = msg[i];
        if (!canBeUsedAsMnemonic(c)) continue;
        if (!usedCharacters.contains(c)) {
          m.index = i;
          usedCharacters.add(c);
          break;
        }
      }
    }
  }
}

class MnemonicProperty {
  Menu text;
  int index;
  MnemonicProperty(this.text, this.index);

  String get mnemonic => text.label.message[index];
}

class I18nMnemonicWidget extends StatefulWidget {
  final Intl i18n;
  final int index;

  const I18nMnemonicWidget({Key? key, required this.i18n, required this.index}) : super(key: key);

  @override
  I18nMnemonicWidgetState createState() => I18nMnemonicWidgetState();
}

class I18nMnemonicWidgetState extends State<I18nMnemonicWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.i18n.message,
      style: TextStyle(decoration: TextDecoration.underline),
    );
    // var index = widget.index;
    // var msg = widget.i18n.message;
    // if (index == -1) return Text(msg);
    // List<TextSpan> children = [];
    // if (index == 0) {
    //   // underlined mnemonic
    //   children.add(TextSpan(text: msg[0], style: const TextStyle(decoration: TextDecoration.underline)));
    //   // rest of the text
    //   children.add(TextSpan(text: msg.substring(1)));
    // } else {
    //   // first part of the text
    //   children.add(TextSpan(text: msg.substring(0, index)));
    //   // underlined mnemonic
    //   children.add(TextSpan(text: msg[index], style: const TextStyle(decoration: TextDecoration.underline)));
    //   // rest of the text
    //   children.add(TextSpan(text: msg.substring(index + 1)));
    // }
    // // return RichText(text: TextSpan(children: children));
    // // use Text.rich instead of RichText to inherit the style
    // return Text.rich(TextSpan(children: children));
  }
}

class I18nBuilderWidget extends StatelessWidget {
  final Intl i18n;
  final Widget Function(BuildContext context, Intl i18n) builder;

  const I18nBuilderWidget({Key? key, required this.builder, required this.i18n}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder(context, i18n);
  }
}

class I18nTextWidget extends StatefulWidget {
  final Intl i18n;

  const I18nTextWidget({super.key, required this.i18n});

  @override
  State<I18nTextWidget> createState() => _I18nTextWidgetState();
}

class _I18nTextWidgetState extends State<I18nTextWidget> {
  @override
  void initState() {
    super.initState();
    widget.i18n.addListener(_onI18nChanged);
  }

  @override
  void dispose() {
    widget.i18n.removeListener(_onI18nChanged);
    super.dispose();
  }

  // this one does not really necessary
  // since the widget is rebuilt when the i18n object changes
  // and the text widget is rebuilt
  // but it is good practice to remove the listener
  @override
  void didUpdateWidget(covariant I18nTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.i18n.removeListener(_onI18nChanged);
    widget.i18n.addListener(_onI18nChanged);
  }

  void _onI18nChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.i18n._message);
  }
}
