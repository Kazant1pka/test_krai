import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:krainet/data/repository/storage_repository.dart';
import 'package:krainet/domain/task.dart';

part 'edit_task_event.dart';
part 'edit_task_state.dart';

//Блок изменения или создания задачи
class EditTaskBloc extends Bloc<EditTaskEvent, EditTaskState> {
  EditTaskBloc({
    required StorageRepository storageRepository,
    required Task? initialTask,
  })  : _storageRepository = storageRepository,
        super(
          EditTaskState(
            initialTask: initialTask,
            title: initialTask?.title ?? '',
            description: initialTask?.description ?? '',
            endsTask: initialTask?.endsTask ?? DateTime.now(),
          ),
        ) {
    on<EditTitleChanged>(_onTitleChanged);
    on<EditDescriptionChanged>(_onDescriptionChanged);
    on<EditDateChanged>(_onDateChanged);
    on<EditTaskSubmitted>(_onSubmitted);
  }
  //Метод, изменяющий название задачи
  void _onTitleChanged(
    EditTitleChanged event,
    Emitter<EditTaskState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  //Метод, изменяющий описание задачи
  void _onDescriptionChanged(
    EditDescriptionChanged event,
    Emitter<EditTaskState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  //Метод, изменяющий время задачи
  void _onDateChanged(
    EditDateChanged event,
    Emitter<EditTaskState> emit,
  ) {
    emit(state.copyWith(endsTask: event.date));
  }

  //Метод, сохраняющий задачу и отправляющий ее в базу данных
  Future<void> _onSubmitted(
    EditTaskSubmitted event,
    Emitter<EditTaskState> emit,
  ) async {
    emit(state.copyWith(status: EditTaskStatus.loading));
    final task =
        (state.initialTask ?? Task(title: '', userId: event.uid)).copyWith(
      title: state.title,
      description: state.description,
      endsTask: state.endsTask,
    );
    try {
      await _storageRepository.saveTask(task);
      emit(state.copyWith(status: EditTaskStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditTaskStatus.failure));
    }
  }

  final StorageRepository _storageRepository;
}
