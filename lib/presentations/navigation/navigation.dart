import 'package:go_router/go_router.dart';
import 'package:krainet/presentations/screens/home.dart';

abstract class Routes {
  static const empty = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const authCheck = '/authCheck';
}

final router = GoRouter(
  initialLocation: Routes.home,
  routes: [
    GoRoute(
      path: Routes.empty,
      redirect: (context, state) => Routes.home,
    ),
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
  ],
);
