import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Config/theme/theme.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/allbookList/book_all_list_data_cubit.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/booksApi/book_api_cubit.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/categoryApi/book_group_api_cubit.dart';
import 'package:flutter_application_1/Features/ContentBooks/presentation/bloc/search/search_group_cubit.dart';
import 'package:flutter_application_1/Features/Home/presentation/bloc/cubit/nav_bar_cubit.dart';
import 'package:flutter_application_1/Features/Home/presentation/home.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/bookGroup/bookgroup_cubit.dart';
import 'package:flutter_application_1/Features/Settings/presentation/bloc/setting_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Platform.isAndroid && !Platform.isIOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

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
          create: (context) => SettingsCubit(),
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeApp.lightTheme,
        home: const HomePage(),
      ),
    );
  }
}
