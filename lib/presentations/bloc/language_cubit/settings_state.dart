part of 'settings_cubit.dart';

enum LangStatus { en, ru }

final class SettingsState extends Equatable {
  const SettingsState({
    this.lang = LangStatus.ru,
    this.isLight = true,
  });

  final LangStatus lang;
  final bool isLight;

  @override
  List<Object> get props => [lang, isLight];
}

final class SettingsInitial extends SettingsState {}
