part of 'settings_cubit.dart';

enum LangStatus { en, ru }

final class SettingsState extends Equatable {
  const SettingsState({
    this.lang = LangStatus.ru,
    this.isLight = true,
  });
  //Язык приложения
  final LangStatus lang;
  //Тема приложения
  final bool isLight;

  @override
  List<Object> get props => [lang, isLight];
}

final class SettingsInitial extends SettingsState {}
