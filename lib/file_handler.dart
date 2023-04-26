import 'package:flutter/material.dart';
import 'package:nodeflow/application.dart';
import 'package:nodeflow/project/project.dart';

class FileHandlerContext extends Context {
  final Map<String, FileHandler> _handlers = {};

  void register(String extension, FileHandler handler) {
    if (nodeflow.isInitialized) throw Exception('Cannot register handler after initialization');
    if (_handlers[extension] != null) throw Exception('Handler for $extension already registered');
    _handlers[extension] = handler;
  }

  FileHandler? getHandler(String extension) {
    return _handlers[extension];
  }
}

abstract class FileHandler {
  Widget buildIcon(BuildContext context, ProjectFile file);
  Future<FileSession> open(Project project, ProjectFile file);
}

// when a file is opened, a FileSession is created respectively to the file
abstract class FileSession extends ChangeNotifier {
  ProjectFile get file;
  List<ProjectAction> get actionBuffer;
}