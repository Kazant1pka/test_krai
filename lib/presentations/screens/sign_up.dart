import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:krainet/data/repository/auth_repository.dart';
import 'package:krainet/l10n/l10n.dart';
import 'package:krainet/presentations/bloc/sign_up_cubit/sign_up_cubit.dart';
import 'package:krainet/presentations/navigation/navigation.dart';
import 'package:krainet/presentations/widgets/input_field.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go(Routes.login),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(l10n.signUpTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider<SignUpCubit>(
          create: (context) => SignUpCubit(context.read<AuthRepository>()),
          child: BlocListener<SignUpCubit, SignUpState>(
            listener: (context, state) {
              if (state.status.isSuccess) {
                context.go(Routes.login);
              }
              if (state.status.isFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ?? l10n.signUpError),
                    ),
                  );
              }
            },
            child: Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    children: [
                      BlocBuilder<SignUpCubit, SignUpState>(
                        buildWhen: (previous, current) =>
                            previous.email != current.email,
                        builder: (context, state) {
                          return InputField(
                            icon: Icons.email_outlined,
                            initialValue: '',
                            labelText: l10n.email,
                            isEnabled: true,
                            onChanged: (email) {
                              context.read<SignUpCubit>().emailChanged(email);
                              return null;
                            },
                            hintText: l10n.emailHint,
                            errorText: state.email.displayError != null
                                ? l10n.emailError
                                : null,
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<SignUpCubit, SignUpState>(
                        buildWhen: (previous, current) =>
                            previous.password != current.password,
                        builder: (context, state) {
                          return InputField(
                            icon: Icons.password,
                            initialValue: '',
                            labelText: l10n.password,
                            isEnabled: true,
                            onChanged: (password) {
                              context
                                  .read<SignUpCubit>()
                                  .passwordChanged(password);
                              return null;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            hintText: l10n.passwordHint,
                            errorText: state.password.displayError != null
                                ? l10n.passwordError
                                : null,
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<SignUpCubit, SignUpState>(
                        buildWhen: (previous, current) =>
                            previous.password != current.password ||
                            previous.confirmedPassword !=
                                current.confirmedPassword,
                        builder: (context, state) {
                          return InputField(
                            icon: Icons.repeat,
                            initialValue: '',
                            labelText: l10n.confirmPassword,
                            isEnabled: true,
                            onChanged: (confirmPassword) {
                              context
                                  .read<SignUpCubit>()
                                  .onConfirmPasswordChanged(confirmPassword);
                              return null;
                            },
                            keyboardType: TextInputType.visiblePassword,
                            hintText: l10n.passwordHint,
                            errorText:
                                state.confirmedPassword.displayError != null
                                    ? context.l10n.errorConfirmPassword
                                    : null,
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      _SignUpButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: state.isValid
                    ? () => context.read<SignUpCubit>().signUpFromSubmitted()
                    : null,
                child: Text(
                  context.l10n.signUp.toUpperCase(),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              );
      },
    );
  }
}
