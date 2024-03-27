import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:krainet/data/repository/auth_repository.dart';
import 'package:krainet/l10n/l10n.dart';
import 'package:krainet/presentations/bloc/language_cubit/settings_cubit.dart';
import 'package:krainet/presentations/bloc/login_cubit/login_cubit.dart';
import 'package:krainet/presentations/navigation/navigation.dart';
import 'package:krainet/presentations/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    var isLight = context.read<SettingsCubit>().state.isLight;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.loginTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isLight = !isLight;
                });
                isLight = !isLight;
                context.read<SettingsCubit>().setTheme(!isLight);
              },
              child: Text(isLight ? 'light' : 'dark'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => LoginCubit(context.read<AuthRepository>()),
          child: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.status.isFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ?? l10n.loginError),
                    ),
                  );
              }
            },
            child: Center(
              child: BlocBuilder<LoginCubit, LoginState>(
                buildWhen: (previous, current) => previous != current,
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Column(
                        children: [
                          InputField(
                            icon: Icons.email_outlined,
                            initialValue: '',
                            labelText: l10n.email,
                            isEnabled: true,
                            onChanged: (email) {
                              context.read<LoginCubit>().emailChanged(email);
                              return null;
                            },
                            hintText: l10n.emailHint,
                            errorText: state.email.displayError != null
                                ? l10n.emailError
                                : null,
                          ),
                          const SizedBox(height: 8),
                          InputField(
                            icon: Icons.password,
                            initialValue: '',
                            labelText: l10n.password,
                            isEnabled: true,
                            onChanged: (password) {
                              context
                                  .read<LoginCubit>()
                                  .passwordChanged(password);
                              return null;
                            },
                            hintText: l10n.passwordHint,
                            errorText: state.password.displayError != null
                                ? l10n.passwordError
                                : null,
                          ),
                          const SizedBox(height: 8),
                          _LoginButton(),
                          const SizedBox(height: 4),
                          _SignUpButton(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: state.isValid
                    ? () => context.read<LoginCubit>().logInWithCredentials()
                    : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: Text(
                  context.l10n.loginTitle.toUpperCase(),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: () => context.go(Routes.signup),
      child: Text(
        context.l10n.signUp.toUpperCase(),
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
