import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:krainet/domain/task.dart';
import 'package:krainet/presentations/bloc/auth_bloc/auth_bloc.dart';
import 'package:krainet/presentations/screens/edit_task.dart';
import 'package:krainet/presentations/screens/home.dart';
import 'package:krainet/presentations/screens/login.dart';
import 'package:krainet/presentations/screens/sign_up.dart';

abstract class Routes {
  static const empty = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const create = '/create';
  static const edit = '/edit';
  static const authCheck = '/authCheck';
}

final router = GoRouter(
  initialLocation: Routes.home,
  routes: [
    GoRoute(
      path: Routes.empty,
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: Routes.signup,
      builder: (context, state) {
        return const SignUpPage();
      },
    ),
    GoRoute(
      path: Routes.create,
      builder: (context, state) {
        return const CreateOrEditTask();
      },
    ),
    GoRoute(
      path: Routes.edit,
      builder: (context, state) {
        final editTask = state.extra as Task?;
        return CreateOrEditTask(initialTask: editTask);
      },
    ),
  ],
  redirect: (context, state) {
    final logIn = state.matchedLocation == Routes.login;
    final home = state.matchedLocation == Routes.home;
    if (context.read<AuthBloc>().state != const AuthState.unauthenticated()) {
      if (logIn) {
        return Routes.home;
      } else {
        return null;
      }
    }
    if (home) {
      return Routes.login;
    }

    return null;
  },
);
