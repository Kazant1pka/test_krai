import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:krainet/data/repository/auth_repository.dart';
import 'package:krainet/domain/user.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheClient extends Mock implements CacheClient {}

class MockFirebaseAuth extends Mock implements firebase.FirebaseAuth {}

void main() {
  const user = User(id: 'id', email: 'email', name: 'name');
  late CacheClient cacheClient;
  late firebase.FirebaseAuth firebaseAuth;

  /// Вызывается перед КАЖДЫМ тестом
  setUp(() {
    cacheClient = MockCacheClient();
    firebaseAuth = MockFirebaseAuth();
  });

  /// Вызывается после КАЖДОГО теста
  // tearDown(() {});

  group('AuthRepository test:', () {
    test('currentUser should return', () {
      when(() => cacheClient.read<User>(key: AuthRepository.userCacheKey))
          .thenReturn(user);
      final repository = AuthRepository(
        cacheClient: cacheClient,
        firebaseAuth: firebaseAuth,
      );
      final expectedUser = repository.currentUser;

      expect(expectedUser, user);
    });

    test('currentUser should return empty user', () {
      when(() => cacheClient.read<User>(key: AuthRepository.userCacheKey))
          .thenReturn(null);
      final repository = AuthRepository(
        cacheClient: cacheClient,
        firebaseAuth: firebaseAuth,
      );
      final expectedUser = repository.currentUser;

      expect(expectedUser, User.empty);
    });
  });
}
