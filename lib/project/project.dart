import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nodeflow/i18n/internationalization.dart';

abstract class Project {
  ValueListenable<String> get name;
  Future<void> setName(String name);

  ValueListenable<String> get description;
  Future<void> setDescription(String description);

  ValueListenable<List<ProjectFile>> get rootDirectory;

  JSONObject get configuration;
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
  I18n get name;
  I18n get description;
  void initHandler(Project project);
  Future<BuildConfiguration> loadConfiguration(JSONObject configuration);
  Future<ConsoleInstance> deployProject(Project project, BuildConfiguration configuration);
  Future<ConsoleInstance> runProject(Project project, BuildConfiguration configuration);
}

abstract class ProjectAuthor {
  String get id;
  String get name;
}

abstract class ProjectAction {
  I18n get name;
  ProjectAuthor get author;
  Future<void> undo();
  Future<void> redo();
}

abstract class ProjectFile {
  String get id;

  ValueListenable<String> get name;
  Future<void> setName(String name);

  // path includes the name
  ValueListenable<String> get path;
  Future<void> setPath(String path);

  // get the content byte data asynchronously
  Future<ByteData> getContent();
  void updateContent(ByteData content);
}

// Structured Project Files, saves JSON into the database, and load it as a map
// the map is also listenable to changes
abstract class StructuredProjectFile extends ProjectFile {
  // invalidate the getContent and updateContent as it should not be used
  // for structured project files
  @override
  Future<ByteData> getContent() {
    throw UnimplementedError();
  }

  @override
  void updateContent(ByteData content) {
    throw UnimplementedError();
  }

  JSONObject get content;
}

abstract class JSONObjectEntry extends ChangeNotifier {
  String get key;

  dynamic get value;
  Future<void> setValue(dynamic value);
}

abstract class JSONObject extends ChangeNotifier {
  bool get isEmpty;
  bool get isNotEmpty => !isEmpty;
  Iterable<String> get key;
  Iterable<dynamic> get values;
  Iterable<JSONObjectEntry> get entries;
  Future<void> clear();
  Future<dynamic> set(String key, Object value);
  Future<dynamic> remove(String key);
  bool containsKey(String key);
  bool contains(String key, Object value);
  String getString(String key);
  int getInt(String key);
  double getDouble(String key);
  bool getBool(String key);
  JSONObject getObject(String key);
  JSONList getList(String key);
  Map<String, dynamic> toMap(); // copies the data
}

abstract class JSONList extends ChangeNotifier {
  dynamic get last;
  dynamic get first;
  Future<void> clear();
  Future<void> addAll(List<Object> values);
  Future<void> addAllAt(int index, List<Object> values);
  Future<int> add(Object value);
  Future<int> insert(int index, Object value);
  Future<int> remove(Object value);
  Future<dynamic> removeAt(int index);
  int get length;
  int indexOf(Object value);
  bool contains(Object value);
  String getString(int index);
  int getInt(int index);
  double getDouble(int index);
  bool getBool(int index);
  JSONObject getObject(int index);
  JSONList getList(int index);
  List<dynamic> toList(); // copies the data
}
