// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Config/theme/theme.dart';
// import 'package:flutter_application_1/Core/utils/save_all.dart';

// part 'theme_state.dart';

// class ThemeCubit extends Cubit<ThemeState> {
//   ThemeCubit()
//       : super(ThemeState(
//             isLight: SaveAll.saveSetting.read('theme') ?? true,
//             theme: SaveAll.saveSetting.read('theme') ?? true
//                 ? ThemeApp.lightTheme
//                 : ThemeApp.darkTheme));

//   changeTheme(bool value) {
//     ThemeData themeData = value ? ThemeApp.lightTheme : ThemeApp.darkTheme;
//     emit(ThemeState(isLight: value, theme: themeData));

//     SaveAll.saveSetting.write('theme', value);
//   }
// }
