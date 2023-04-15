import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nodeflow/editor/editor.dart';
import 'package:nodeflow/i18n/internationalization.dart';
import 'package:nodeflow/ui/compact_ui.dart';

void main() async {
  // check if platform is html
  if (kIsWeb) {
    // set the title of the page
    document.title = 'Nodeflow';
    window.document.onContextMenu.listen((event) => event.preventDefault());
  }
  WidgetsFlutterBinding.ensureInitialized();
  await reloadMessages();
  runApp(MaterialApp(
    title: 'Nodeflow',
    debugShowCheckedModeBanner: false,
    home: CompactUI(child: Editor()),
  ));
}
