import 'package:_imagineeringwithus_pack/setup/index.dart';
import 'package:bloc/bloc.dart'; 
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:temp_package_name/src/utils/utils.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState()) {
    on<InitThemeEvent>(_onInit);
    on<ChangedThemeEvent>(_onChanged);
  }
  _onInit(InitThemeEvent event, emit) {
    bool isDark = AppPrefs.instance.themeModel == AppPrefsBase.themeModeDarkKey;
    emit(state.update(isDark: isDark));
  }

  _onChanged(ChangedThemeEvent event, emit) {
    if (event.isNeedUpdateStatusbar) {}
    AppPrefs.instance.themeModel = event.isDark
        ? AppPrefsBase.themeModeDarkKey
        : AppPrefsBase.themeModeLightKey;
    emit(state.update(isDark: event.isDark)); 
  }
}
