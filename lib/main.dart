import 'package:flutter/material.dart';
import 'package:krainet/l10n/l10n.dart';
import 'package:krainet/presentations/navigation/navigation.dart';
import 'package:krainet/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TaskOrganizer());
}

class TaskOrganizer extends StatelessWidget {
  const TaskOrganizer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Organizer',
      routerConfig: router,
    );
  }
}
