part of 'tasks_overview_bloc.dart';

sealed class TasksOverviewEvent extends Equatable {
  const TasksOverviewEvent();

  @override
  List<Object> get props => [];
}

//Событие запроса для получения задач пользователя
final class TasksRequested extends TasksOverviewEvent {
  const TasksRequested(this.uid);
  //id пользователя
  final String uid;

  @override
  List<Object> get props => [uid];
}

//Событие при выполнение задачи пользователем
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

//Событие при удалении задачи
final class TaskDeleted extends TasksOverviewEvent {
  const TaskDeleted(this.task, this.uid);

  final String uid;
  final Task task;

  @override
  List<Object> get props => [task, uid];
}

//Событие фильтрации задач пользователя
final class TasksFilterChanged extends TasksOverviewEvent {
  const TasksFilterChanged(this.filter);

  final TasksViewFilter filter;

  @override
  List<Object> get props => [filter];
}

//Событие сортировки задач пользователя
final class TasksSortChanged extends TasksOverviewEvent {
  const TasksSortChanged(this.sort);

  final TasksViewSort sort;

  @override
  List<Object> get props => [sort];
}
