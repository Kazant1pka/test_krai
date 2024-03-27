import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:krainet/l10n/l10n.dart';
import 'package:krainet/presentations/bloc/auth_bloc/auth_bloc.dart';
import 'package:krainet/presentations/bloc/language_cubit/settings_cubit.dart';
import 'package:krainet/presentations/navigation/navigation.dart';
import 'package:krainet/presentations/screens/task_overview.dart';
import 'package:krainet/utils/colors.dart';

//Начальный экран приложения авторизованного пользователя
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    var isLight = context.read<SettingsCubit>().state.isLight;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.mainTitle),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            //Смена темы приложения
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isLight = !isLight;
                });
                isLight = !isLight;
                context.read<SettingsCubit>().setTheme(isLight: !isLight);
              },
              child: Text(isLight ? context.l10n.light : context.l10n.dark),
            ),
          ),
          //Выход авторизованного пользователя
          IconButton(
            tooltip: user.email,
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: const TaskOverviewPage(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => context.go(Routes.create),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: AppColors.lightBackground,
        shape: CircularNotchedRectangle(),
      ),
    );
  }
}
