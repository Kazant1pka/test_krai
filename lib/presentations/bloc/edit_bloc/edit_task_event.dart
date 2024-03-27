part of 'edit_task_bloc.dart';

sealed class EditTaskEvent extends Equatable {
  const EditTaskEvent();

  @override
  List<Object> get props => [];
}

//Событие измнения названия задачи
final class EditTitleChanged extends EditTaskEvent {
  const EditTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

//Событие измнения описания задачи
final class EditDescriptionChanged extends EditTaskEvent {
  const EditDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

//Событие измнения даты задачи
final class EditDateChanged extends EditTaskEvent {
  const EditDateChanged(this.date);

  final DateTime date;

  @override
  List<Object> get props => [date];
}

//Событие подтверждающее сохранение хадачи
final class EditTaskSubmitted extends EditTaskEvent {
  const EditTaskSubmitted(this.uid);

  final String uid;

  @override
  List<Object> get props => [uid];
}
