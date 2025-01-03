import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Features/Settings/presentation/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  void changeTheme(String theme) => emit(state.copyWith(selectedTheme: theme));
  void changeFontSize(double size) => emit(state.copyWith(fontSize: size));
  void changeLineSpacing(double spacing) =>
      emit(state.copyWith(lineSpacing: spacing));
  void changeFont(String font) => emit(state.copyWith(selectedFont: font));
  void changeBackgroundColor(Color color) =>
      emit(state.copyWith(selectedBackgroundColor: color));
  void changeThemeMode(bool value) {
    if (!value) {
      StorageLastTheme.lastTheme = state.selectedBackgroundColor;
      emit(state.copyWith(selectedBackgroundColor: Colors.grey.shade800));
    } else {
      emit(state.copyWith(selectedBackgroundColor: StorageLastTheme.lastTheme));
    }

    emit(state.copyWith(isLightMode: value));
  }

  void changePageOrientation(String orientation) => emit(state.copyWith(
      pageOrientation: orientation,
      axix: state.axix == Axis.horizontal ? Axis.vertical : Axis.horizontal));
}

class StorageLastTheme {
  static Color lastTheme = Colors.white;
}
