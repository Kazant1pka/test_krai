import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_state.dart';

//Состояние глобальных настоек приложения
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());
  //Применение языка приложения
  void setLang(LangStatus changedLang) =>
      emit(SettingsState(lang: changedLang));
  //Применения темы приложения
  void setTheme({required bool isLight}) =>
      emit(SettingsState(isLight: isLight));
}
