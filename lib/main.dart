import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:krainet/data/initilizer/storage.dart';
import 'package:krainet/data/repository/auth_repository.dart';
import 'package:krainet/data/repository/storage_repository.dart';
import 'package:krainet/firebase_options.dart';
import 'package:krainet/l10n/l10n.dart';
import 'package:krainet/presentations/bloc/auth_bloc/auth_bloc.dart';
import 'package:krainet/presentations/bloc/language_cubit/settings_cubit.dart';
import 'package:krainet/presentations/navigation/navigation.dart';
import 'package:krainet/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Инициализация Firebase в приложении
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //Инициализация пользовательского репозитория
  final authRepository = AuthRepository();
  await authRepository.user.first;
  final todosApi = Storage(plugin: FirebaseFirestore.instance);
  final storageRepository = StorageRepository(storageData: todosApi);
  //Запуск приложения
  runApp(
    TaskOrganizer(
      authRepository: authRepository,
      storageRepository: storageRepository,
    ),
  );
}

class TaskOrganizer extends StatelessWidget {
  const TaskOrganizer({
    required AuthRepository authRepository,
    required StorageRepository storageRepository,
    super.key,
  })  : _authRepository = authRepository,
        _storageRepository = storageRepository;

  final AuthRepository _authRepository;
  final StorageRepository _storageRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _authRepository,
        ),
        RepositoryProvider.value(
          value: _storageRepository,
        ),
      ],
      child: BlocProvider(
        create: (context) => SettingsCubit(),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final locale = context.read<SettingsCubit>().state.lang.name;
            final isLight = context.read<SettingsCubit>().state.isLight;
            return BlocProvider(
              create: (context) => AuthBloc(authRepository: _authRepository),
              child: BlocListener<AuthBloc, AuthState>(
                listenWhen: (previous, current) => previous != current,
                listener: (context, state) {
                  //Обновление маршрутов приложения при входе
                  router.refresh();
                },
                child: MaterialApp.router(
                  theme: isLight ? AppTheme.light : AppTheme.dark,
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: [Locale(locale)],
                  title: 'Organizer',
                  routerConfig: router,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
