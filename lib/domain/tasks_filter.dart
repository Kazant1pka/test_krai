import 'package:krainet/domain/task.dart';

enum TasksViewFilter { all, activeonly, completedOnle }

extension TasksViewFilterX on TasksViewFilter {
  bool apply(Task task) {
    switch (this) {
      case TasksViewFilter.all:
        return true;
      case TasksViewFilter.activeonly:
        return !task.isCompleted;
      case TasksViewFilter.completedOnle:
        return task.isCompleted;
    }
  }

  Iterable<Task> applyAll(Iterable<Task> tasks) {
    return tasks.where(apply);
  }
}
