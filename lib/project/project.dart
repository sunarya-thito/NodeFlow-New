import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nodeflow/application.dart';
import 'package:nodeflow/i18n/internationalization.dart';

abstract class Project extends Context {
  ValueListenable<String> get name;
  Future<void> setName(String name);

  ValueListenable<String> get description;
  Future<void> setDescription(String description);
}

abstract class ProjectDeployment extends Context {
  List<BuildConfiguration> get buildConfigurations;
  void remove(BuildConfiguration configuration);
  void add(BuildConfiguration configuration);
}

abstract class ProjectResources extends Context {
  List<ProjectFile> get files;
}

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

class LogRecord {
  final LogLevel level;
  final String message;
  final DateTime time;

  LogRecord(this.level, this.message, this.time);

  Map<String, dynamic> toJson() {
    return {
      'level': level.toString(),
      'message': message,
      'time': time.toIso8601String(),
    };
  }

  static LogRecord fromJson(Map<String, dynamic> json) {
    return LogRecord(
      LogLevel.values.firstWhere((element) => element.toString() == json['level']),
      json['message'],
      DateTime.parse(json['time']),
    );
  }
}

abstract class ConsoleInstance {
  void addListener(void Function(LogRecord message) listener);
  void removeListener(void Function(LogRecord message) listener);
  // this also stops the process
  void dispose();
}

abstract class BuildConfiguration extends ChangeNotifier {
  String get name;
  Future<void> setName(String name);
  Widget createConfigurationWidget(BuildContext context);
}

// ProjectHandler is basically the project type
// types are:
// - SpigotMC plugin projects
// - Arduino projects
// - Flutter projects
// - more to come
abstract class ProjectHandler {
  Intl get name;
  Intl get description;
  void initHandler(Application state, Project project);

  Future<ConsoleInstance> deployProject(Project project, BuildConfiguration configuration);
  Future<ConsoleInstance> runProject(Project project, BuildConfiguration configuration);

  Future<BuildConfiguration> deserializeBuildConfiguration(Map<String, dynamic> json);
  Future<Map<String, dynamic>> serializeBuildConfiguration(BuildConfiguration configuration);

  Future<ProjectAuthor> deserializeAuthor(Map<String, dynamic> json);
  Future<Map<String, dynamic>> serializeAuthor(ProjectAuthor author);

  Future<ProjectAction> deserializeAction(Map<String, dynamic> json);
  Future<Map<String, dynamic>> serializeAction(ProjectAction action);
}

abstract class ProjectAuthor {
  String get id;
  String get name;
}

abstract class ProjectAction {
  Intl get name;
  ProjectAuthor get author;
  Future<void> undo(Project project);
  Future<void> redo(Project project);
}

abstract class ProjectFile {
  String get id;

  bool get isLocked; // if locked, the file can't be changed
  Key requestLock(); // throws if locked
  void releaseLock(Key key); // throws if key is invalid

  // name excludes the extension
  ValueListenable<String> get name;
  Future<void> setName(String name); // throws if locked

  String get extension; // you can't change the extension

  // path excludes the name
  ValueListenable<String> get path;
  Future<void> setPath(String path); // throws if locked

  // get the content byte data asynchronously
  Future<ByteData> getContent(); // throws if locked
  void updateContent(ByteData content); // throws if locked
}
