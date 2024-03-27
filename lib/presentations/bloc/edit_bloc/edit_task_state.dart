part of 'edit_task_bloc.dart';

enum EditTaskStatus { initial, loading, success, failure }

extension EditTaskStatusX on EditTaskStatus {
  bool get isLoadingOrSuccess => [
        EditTaskStatus.loading,
        EditTaskStatus.success,
      ].contains(this);
}

//Общее состояние задачи
final class EditTaskState extends Equatable {
  EditTaskState({
    this.status = EditTaskStatus.initial,
    this.initialTask,
    this.title = '',
    this.description = '',
    DateTime? endsTask,
  }) : endsTask = endsTask ?? DateTime.now();

  final EditTaskStatus status;
  final Task? initialTask;
  final String title;
  final String description;
  final DateTime endsTask;

  //Получение данных о том, что это новая задача или редактивание старой
  bool get isNewTask => initialTask == null;

  EditTaskState copyWith({
    EditTaskStatus? status,
    Task? initialTodo,
    String? title,
    String? description,
    DateTime? endsTask,
  }) {
    return EditTaskState(
      status: status ?? this.status,
      initialTask: initialTodo ?? initialTask,
      title: title ?? this.title,
      description: description ?? this.description,
      endsTask: endsTask ?? this.endsTask,
    );
  }

  @override
  List<Object?> get props =>
      [status, initialTask, title, description, endsTask];
}

final class EditTaskInitial extends EditTaskState {}
