part of 'tasks_overview_bloc.dart';

sealed class TasksOverviewEvent extends Equatable {
  const TasksOverviewEvent();

  @override
  List<Object> get props => [];
}

final class TasksRequested extends TasksOverviewEvent {
  const TasksRequested(this.uid);

  final String uid;

  @override
  List<Object> get props => [uid];
}

final class TasksCompletionToggled extends TasksOverviewEvent {
  const TasksCompletionToggled({
    required this.uid,
    required this.task,
    required this.isCompleted,
  });

  final String uid;
  final Task task;
  final bool isCompleted;

  @override
  List<Object> get props => [task, isCompleted, uid];
}

final class TaskDeleted extends TasksOverviewEvent {
  const TaskDeleted(this.task, this.uid);

  final String uid;
  final Task task;

  @override
  List<Object> get props => [task, uid];
}

final class TasksFilterChanged extends TasksOverviewEvent {
  const TasksFilterChanged(this.filter);

  final TasksViewFilter filter;

  @override
  List<Object> get props => [filter];
}

final class TasksClearCompletedRequested extends TasksOverviewEvent {
  const TasksClearCompletedRequested();
}
