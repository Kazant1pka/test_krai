import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  void setLang(LangStatus changedLang) =>
      emit(SettingsState(lang: changedLang));

  void setTheme(bool isLight) => emit(SettingsState(isLight: isLight));
}
