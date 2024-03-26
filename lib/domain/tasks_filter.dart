import 'package:krainet/domain/task.dart';

enum TasksViewFilter { all, activeonly, completedOnle }

extension TasksViewFilterX on TasksViewFilter {
  bool apply(Task todo) {
    switch (this) {
      case TasksViewFilter.all:
        return true;
      case TasksViewFilter.activeonly:
        return !todo.isCompleted;
      case TasksViewFilter.completedOnle:
        return todo.isCompleted;
    }
  }

  Iterable<Task> applyAll(Iterable<Task> todos) {
    return todos.where(apply);
  }
}
