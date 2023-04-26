import 'package:nodeflow/application.dart' as application;
import 'package:nodeflow/project/project.dart';

abstract class NodeFlowProjectHandler extends ProjectHandler {
  @override
  void initHandler(application.Application state, Project project) {}
}
