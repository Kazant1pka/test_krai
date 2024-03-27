import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:krainet/data/repository/storage_repository.dart';
import 'package:krainet/domain/task.dart';
import 'package:krainet/domain/tasks_filter.dart';
import 'package:krainet/domain/tasks_sort.dart';

part 'tasks_overview_event.dart';
part 'tasks_overview_state.dart';

//Блок задач
class TasksOverviewBloc extends Bloc<TasksOverviewEvent, TasksOverviewState> {
  TasksOverviewBloc({required StorageRepository storageRepository})
      : _storageRepository = storageRepository,
        super(const TasksOverviewState()) {
    on<TasksRequested>(_onSubscriptionRequested);
    on<TasksCompletionToggled>(_onTaskCompletionToggled);
    on<TaskDeleted>(_onTaskDeleted);
    on<TasksFilterChanged>(_onFilterChanged);
    on<TasksSortChanged>(_onSortChanged);
  }

  final StorageRepository _storageRepository;
  //Метод получения задач авторизованного пользователя
  Future<void> _onSubscriptionRequested(
    TasksRequested event,
    Emitter<TasksOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => TasksOverviewStatus.loading));
    final uid = event.uid;
    await emit.forEach<List<Task>>(
      _storageRepository.getTasks(uid).asStream(),
      onData: (tasks) => state.copyWith(
        status: () => TasksOverviewStatus.success,
        tasks: () => tasks,
      ),
      onError: (_, __) => state.copyWith(
        status: () => TasksOverviewStatus.failure,
      ),
    );
  }

  //Метод выполнения задачи пользователем
  Future<void> _onTaskCompletionToggled(
    TasksCompletionToggled event,
    Emitter<TasksOverviewState> emit,
  ) async {
    emit(state.copyWith(status: () => TasksOverviewStatus.loading));
    final tasks = state.tasks;
    final index = tasks.indexWhere((element) => element.id == event.task.id);
    tasks[index] = tasks[index].copyWith(isCompleted: event.isCompleted);
    emit(
      state.copyWith(
        status: () => TasksOverviewStatus.success,
        tasks: () => tasks,
      ),
    );
    final task = event.task.copyWith(isCompleted: event.isCompleted);
    await _storageRepository.saveTask(task);
  }

  //Метод удаления задачи авторизованного пользователя
  Future<void> _onTaskDeleted(
    TaskDeleted event,
    Emitter<TasksOverviewState> emit,
  ) async {
    await _storageRepository.deleteTask(event.task);
  }

  //Метод фильтрации задач авторизованного пользователя
  Future<void> _onFilterChanged(
    TasksFilterChanged event,
    Emitter<TasksOverviewState> emit,
  ) async {
    emit(state.copyWith(filter: () => event.filter));
  }

//Метод сортровки задач авторизованного пользователя
  Future<void> _onSortChanged(
    TasksSortChanged event,
    Emitter<TasksOverviewState> emit,
  ) async {
    emit(state.copyWith(sort: () => event.sort));
  }
}
