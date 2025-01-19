import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Core/utils/local_storage.dart';
import 'package:flutter_application_1/Features/Settings/presentation/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  void initSetting() {
    final lineSpacing = LocalStorage.storage.read('lineSpacing') ?? 30.0;
    final themePage =
        LocalStorage.storage.read('themePage') ?? Colors.white.value;
    final axis = LocalStorage.storage.read('axis') ?? 'عمودی';
    final fontSize = LocalStorage.storage.read('fontsize') ?? 14.0;
    final themeApp =
        LocalStorage.storage.read('themeApp') ?? const Color(0xFF8D6E63).value;
    bool darkmode = LocalStorage.storage.read('darkmode') ?? true;
    final fontFamily = LocalStorage.storage.read('fontfamilyApp') ?? 'بهیج';

    emit(state.copyWith(
        isLightMode: darkmode,
        selectedBackgroundColor: themeApp,
        lineSpacing: lineSpacing,
        selectedPageColor: themePage,
        axix: axis == 'عمودی' ? Axis.vertical : Axis.horizontal,
        fontSize: fontSize,
        selectedFont: fontFamily));
  }

  void changeTheme(String theme) => emit(state.copyWith(selectedTheme: theme));
  void changeFontSize(double size) {
    emit(state.copyWith(fontSize: size));
    LocalStorage.storage.write('fontsize', size);
  }

  void changeLineSpacing(double spacing) {
    emit(state.copyWith(lineSpacing: spacing));
    LocalStorage.storage.write('lineSpacing', spacing);
  }

  void changeFont(String font) {
    emit(state.copyWith(selectedFont: font));
    LocalStorage.storage.write('fontfamilyApp', font);
  }

  void changeBackgroundColor(Color color) {
    emit(state.copyWith(selectedBackgroundColor: color.value));
    LocalStorage.storage.write('themeApp', color.value);
  }

  void changeThemeMode(bool value) {
    if (!value) {
      StorageLastTheme.lastTheme = state.selectedBackgroundColor;
      emit(state.copyWith(selectedBackgroundColor: Colors.grey.shade800.value));
      LocalStorage.storage.write('themeApp', Colors.grey.shade800.value);
    } else {
      emit(state.copyWith(selectedBackgroundColor: StorageLastTheme.lastTheme));
      LocalStorage.storage.write('themeApp', StorageLastTheme.lastTheme);
    }
    LocalStorage.storage.write('darkmode', value);
    emit(state.copyWith(isLightMode: value));
  }

  void changePageOrientation(String orientation) {
    emit(state.copyWith(
        pageOrientation: orientation,
        axix: state.axix == Axis.horizontal ? Axis.vertical : Axis.horizontal));
    LocalStorage.storage.write('axis', orientation);
  }

  void changePageColor(Color color) {
    emit(state.copyWith(selectedPageColor: color.value));

    LocalStorage.storage.write('themePage', color.value);
  }
}

class StorageLastTheme {
  static int lastTheme = const Color(0xFF8D6E63).value;
}
