part of 'tasks_overview_bloc.dart';

enum TasksOverviewStatus { initial, loading, success, failure }

final class TasksOverviewState extends Equatable {
  const TasksOverviewState({
    this.status = TasksOverviewStatus.initial,
    this.tasks = const [],
    this.filter = TasksViewFilter.all,
  });

  final TasksOverviewStatus status;
  final List<Task> tasks;
  final TasksViewFilter filter;

  Iterable<Task> get filteredTasks => filter.applyAll(tasks);

  TasksOverviewState copyWith({
    TasksOverviewStatus Function()? status,
    List<Task> Function()? tasks,
    TasksViewFilter Function()? filter,
  }) {
    return TasksOverviewState(
      status: status != null ? status() : this.status,
      tasks: tasks != null ? tasks() : this.tasks,
      filter: filter != null ? filter() : this.filter,
    );
  }

  @override
  List<Object> get props => [status, tasks, filter];
}

final class TasksOverviewInitial extends TasksOverviewState {}
