import 'package:flutter/foundation.dart';
import 'package:nodeflow/application.dart';

class TaskManager extends Context {
  final List<RunningTask> _runningTasks = [];

  double get progress {
    if (_runningTasks.isEmpty) return 1;
    final total = _runningTasks.fold<int>(
        0,
        (previousValue, element) =>
            previousValue + (element._currentProgress?.total ?? 0));
    final progress = _runningTasks.fold<int>(
        0,
        (previousValue, element) =>
            previousValue + (element._currentProgress?.progress ?? 0));
    if (total == 0) return 0;
    return progress / total;
  }

  RunningTask submit(Task task) {
    final request = TaskRequest();
    final progress = task.execute(request);
    final runningTask = RunningTask(task, request, progress);
    _runningTasks.add(runningTask);
    progress.listen((event) {
      if (event.progress == event.total) {
        _runningTasks.remove(runningTask);
      }
      notifyListeners();
    }, onDone: () {
      _runningTasks.remove(runningTask);
      notifyListeners();
    }, onError: (error, stackTrace) {
      _runningTasks.remove(runningTask);
      notifyListeners();
    }, cancelOnError: true);
    notifyListeners();
    return runningTask;
  }
}

class TaskRequest {
  bool _cancel = false;

  bool get isCancelled => _cancel;

  void check() {
    if (_cancel) {
      throw InterruptedTaskException();
    }
  }
}

class TaskProgress {
  final int progress;
  final int total;
  final String message;

  const TaskProgress(this.progress, this.total, this.message);

  double get percentage => total == 0 ? 0 : progress / total;

  static const TaskProgress empty = TaskProgress(0, 0, '');
}

abstract class Task {
  final Key key = UniqueKey();
  Stream<TaskProgress> execute(TaskRequest request);
}

class InterruptedTaskException implements Exception {}

class RunningTask extends ValueListenable<TaskProgress> with ChangeNotifier {
  final Task task;
  final TaskRequest request;
  final Stream<TaskProgress> progress;

  TaskProgress? _currentProgress;

  RunningTask(this.task, this.request, this.progress) {
    progress.listen((event) {
      _currentProgress = event;
      notifyListeners();
    });
  }

  @override
  TaskProgress get value => _currentProgress ?? TaskProgress.empty;

  bool get isCancelled => request.isCancelled;

  void cancel() {
    request._cancel = true;
  }
}
