import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:krainet/data/data_source/storage_data.dart';
import 'package:krainet/data/repository/auth_repository.dart';
import 'package:krainet/data/repository/storage_repository.dart';
import 'package:krainet/domain/task.dart';
import 'package:krainet/domain/user.dart';
import 'package:krainet/main.dart';
import 'package:krainet/presentations/screens/login.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockStorageData implements StorageData {
  final tasks = <Task>[];

  @override
  Future<void> deleteTask(Task task) async {
    tasks.removeWhere((element) => element.id == task.id);
  }

  @override
  Future<List<Task>> getTasks(String id) async {
    return tasks;
  }

  @override
  Future<void> saveTask(Task task) async {
    tasks.add(task);
  }
}

void main() {
  const email = 'test@email.com';
  const password = '123456780';
  late AuthRepository authRepository;
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    authRepository = MockAuthRepository();
  });

  testWidgets('should login', (tester) async {
    when(
      () => authRepository.logInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    ).thenAnswer((invocation) => Future.value());
    when(() => authRepository.currentUser).thenReturn(User.empty);
    when(() => authRepository.user)
        .thenAnswer((invocation) => const Stream.empty());

    await tester.pumpWidget(
      TaskOrganizer(
        authRepository: authRepository,
        storageRepository: StorageRepository(storageData: MockStorageData()),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(LoginScreen.emailFieldKey), email);
    await tester.enterText(find.byKey(LoginScreen.passwordFieldKey), password);

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(LoginScreen.loginButtonKey));
  });
}
