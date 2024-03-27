import 'package:krainet/domain/task.dart';

enum TasksViewSort { all, comingDays, notSoon }

extension TasksViewFilterX on TasksViewSort {
  Iterable<Task> apply(Iterable<Task> tasks) {
    switch (this) {
      case TasksViewSort.all:
        return tasks;
      case TasksViewSort.comingDays:
        return tasks.toList()..sort((a, b) => a.endsTask.compareTo(b.endsTask));
      case TasksViewSort.notSoon:
        return tasks.toList()..sort((b, a) => a.endsTask.compareTo(b.endsTask));
    }
  }

  Iterable<Task> applyAll(Iterable<Task> tasks) {
    return apply(tasks);
  }
}
