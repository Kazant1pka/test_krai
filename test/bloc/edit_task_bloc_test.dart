import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:krainet/data/repository/storage_repository.dart';
import 'package:krainet/domain/task.dart';
import 'package:krainet/presentations/bloc/edit_bloc/edit_task_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockStorageRepository extends Mock implements StorageRepository {}

class FakeTask extends Fake implements Task {}

void main() {
  const modifiedTitle = 'modifiedTitle';
  const uid = 'uid';
  final task = Task(
    title: 'Title',
    userId: 'userId',
    description: 'description',
    endsTask: DateTime(2020),
  );
  late StorageRepository storageRepository;

  setUp(() {
    storageRepository = MockStorageRepository();
    registerFallbackValue(FakeTask());
  });
  group('EditTaskBloc test:', () {
    blocTest<EditTaskBloc, EditTaskState>(
      'Should have initial state',
      build: () => EditTaskBloc(
        storageRepository: storageRepository,
        initialTask: task,
      ),
      verify: (bloc) => expect(
        bloc.state,
        EditTaskState(
          initialTask: task,
          title: task.title,
          description: task.description,
          endsTask: task.endsTask,
        ),
      ),
    );

    blocTest<EditTaskBloc, EditTaskState>(
      'Should change title',
      build: () => EditTaskBloc(
        storageRepository: storageRepository,
        initialTask: task,
      ),
      act: (bloc) => bloc.add(const EditTitleChanged(modifiedTitle)),
      expect: () => [
        isA<EditTaskState>().having(
          (state) => state.title,
          'should be modified',
          modifiedTitle,
        ),
      ],
    );

    blocTest<EditTaskBloc, EditTaskState>(
      'Should submit task',
      setUp: () {
        when(() => storageRepository.saveTask(any()))
            .thenAnswer((invocation) => Future.value());
      },
      build: () => EditTaskBloc(
        storageRepository: storageRepository,
        initialTask: task,
      ),
      act: (bloc) => bloc.add(const EditTaskSubmitted(uid)),
      expect: () => [
        isA<EditTaskState>().having(
          (state) => state.status,
          'should be loading',
          EditTaskStatus.loading,
        ),
        isA<EditTaskState>().having(
          (state) => state.status,
          'should be success',
          EditTaskStatus.success,
        ),
      ],
    );

    blocTest<EditTaskBloc, EditTaskState>(
      'Should fali sumbitting',
      setUp: () {
        when(() => storageRepository.saveTask(any())).thenThrow(TypeError());
      },
      build: () => EditTaskBloc(
        storageRepository: storageRepository,
        initialTask: task,
      ),
      act: (bloc) => bloc.add(const EditTaskSubmitted(uid)),
      expect: () => [
        isA<EditTaskState>().having(
          (state) => state.status,
          'should be loading',
          EditTaskStatus.loading,
        ),
        isA<EditTaskState>().having(
          (state) => state.status,
          'should be failure',
          EditTaskStatus.failure,
        ),
      ],
    );
  });
}
