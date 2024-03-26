part of 'edit_task_bloc.dart';

sealed class EditTaskEvent extends Equatable {
  const EditTaskEvent();

  @override
  List<Object> get props => [];
}

final class EditTitleChanged extends EditTaskEvent {
  const EditTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

final class EditDescriptionChanged extends EditTaskEvent {
  const EditDescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}

final class EditDateChanged extends EditTaskEvent {
  const EditDateChanged(this.date);

  final DateTime date;

  @override
  List<Object> get props => [date];
}

final class EditTaskSubmitted extends EditTaskEvent {
  const EditTaskSubmitted(this.uid);

  final String uid;

  @override
  List<Object> get props => [uid];
}
