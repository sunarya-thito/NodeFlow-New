import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nodeflow/action.dart' as action;
import 'package:nodeflow/actions/action_build_configuration.dart';
import 'package:nodeflow/actions/action_deploy.dart';
import 'package:nodeflow/actions/action_edit.dart';
import 'package:nodeflow/actions/action_file.dart';
import 'package:nodeflow/actions/action_help.dart';
import 'package:nodeflow/actions/action_new.dart';
import 'package:nodeflow/actions/action_run.dart';
import 'package:nodeflow/actions/action_tools.dart';
import 'package:nodeflow/actions/action_view.dart';
import 'package:nodeflow/editor/editor.dart';
import 'package:nodeflow/hotkey.dart';
import 'package:nodeflow/i18n/internationalization.dart';
import 'package:nodeflow/project/project.dart';
import 'package:nodeflow/search/search_engine.dart';
import 'package:nodeflow/ui/compact_ui.dart';

late Application nodeflow;

Future<void> initializeApplication([Project? project]) async {
  nodeflow = Application();

  // PRELOAD
  WidgetsFlutterBinding.ensureInitialized();
  await reloadMessages('en_us.json');

  // CONTEXTS
  nodeflow.registerContext(action.ActionContext());
  nodeflow.registerContext(SearchEngine());
  nodeflow.registerContext(HotkeyBindings());
  if (project != null) {
    nodeflow.registerContext(project);
  }

  // ACTIONS
  // WARN: ORDER MATTERS!!!
  var actionContext = nodeflow.getContext<action.ActionContext>();
  actionContext.registerAction(ActionFile());
  actionContext.registerAction(ActionNew(), parent: ActionFile.actionKey);
  actionContext.registerAction(ActionEdit());
  actionContext.registerAction(ActionTools());
  actionContext.registerAction(ActionView());
  actionContext.registerAction(ActionHelp());

  actionContext.registerAction(ActionBuildConfiguration(), parent: ActionTools.actionKey);
  actionContext.registerAction(ActionRun(), parent: ActionTools.actionKey);
  actionContext.registerAction(ActionDeploy(), parent: ActionTools.actionKey);

  // DEFAULT KEYBINDINGS
  var hotkeyContext = nodeflow.getContext<HotkeyBindings>();
  hotkeyContext.bind(ActionDeploy.actionKey, ShortcutKey.fromString('f10'));

  // INITIALIZATION
  nodeflow._initialized = true;
  for (var context in nodeflow._contexts) {
    context.onInitialize();
  }

  // HIDE THE PRELOADER
  if (kIsWeb) {
    // execute after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      window.document.querySelector('#preloader')?.classes.add('preloader-gone');
    });
  }

  // RUN
  runApp(const MaterialApp(
    title: 'Nodeflow',
    debugShowCheckedModeBanner: false,
    home: CompactUI(child: Editor()),
  ));
}

bool kIgnoreWarnings = false;

class Application {
  final List<Context> _contexts = [];

  bool _initialized = false;

  bool get isInitialized => _initialized;

  T getContext<T extends Context>() {
    for (var c in _contexts) {
      if (c is T) return c;
    }
    throw Exception('Context not found');
  }

  void registerContext(Context context) {
    _contexts.add(context);
  }
}

abstract class Context extends ChangeNotifier {
  Key get key => Key(runtimeType.toString());
  void onInitialize() {}
  Map<String, dynamic>? toJson() {
    return null;
  }

  void fromJson(Map<String, dynamic> json) {}

  @override
  void notifyListeners() {
    if (!nodeflow._initialized) return;
    super.notifyListeners();
  }
}
