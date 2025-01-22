import 'package:flutter/material.dart';
import 'package:flutter_application_1/Config/theme/theme.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/allbookList/book_all_list_data_cubit.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/booksApi/book_api_cubit.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/categoryApi/book_group_api_cubit.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/bloc/search/search_group_cubit.dart';
import 'package:flutter_application_1/Features/Home/presentation/bloc/cubit/nav_bar_cubit.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/bookGroup/bookgroup_cubit.dart';
import 'package:flutter_application_1/Features/Search/presentation/bloc/cubit/search_books_cubit.dart';
import 'package:flutter_application_1/Features/Settings/presentation/bloc/setting_cubit.dart';
import 'package:flutter_application_1/Features/Settings/presentation/bloc/settings_state.dart';
import 'package:flutter_application_1/Features/Splash/presentation/splash.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NavBarCubit(),
        ),
        BlocProvider(
          create: (context) => BookgroupCubit(),
        ),
        BlocProvider(
          create: (context) => SettingsCubit()..initSetting(),
        ),
        BlocProvider(
          create: (context) => BookGroupApiCubit(),
        ),
        BlocProvider(
          create: (context) => BookApiCubit(),
        ),
        BlocProvider(
          create: (context) => BookAllListDataCubit(),
        ),
        BlocProvider(
          create: (context) => SearchGroupCubit(),
        ),
        BlocProvider(
          create: (_) => SearchBooksCubit(),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeApp.lightTheme(Color(state.selectedBackgroundColor)),
            home: const Splash(),
          );
        },
      ),
    );
  }
}
