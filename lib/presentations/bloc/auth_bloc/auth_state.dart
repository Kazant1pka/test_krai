part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated }

//Состояние блока авторизации(авторизован и не авторизован)
final class AuthState extends Equatable {
  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);
  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState._({
    required this.status,
    this.user = User.empty,
  });

  final AuthStatus status;
  final User user;

  @override
  List<Object> get props => [status, user];
}
