part of 'auth_bloc.dart';

//Событие авторизации
sealed class AuthEvent {
  const AuthEvent();
}

//Событие при котором пользователь выходит из своего задачника
final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

//Событие при котором пользователь входит в задачник
final class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.user);

  final User user;
}
