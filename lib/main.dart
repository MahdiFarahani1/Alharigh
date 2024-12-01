import 'package:flutter/material.dart';
import 'package:flutter_application_1/Config/theme/theme.dart';
import 'package:flutter_application_1/Features/Home/presentation/bloc/cubit/nav_bar_cubit.dart';
import 'package:flutter_application_1/Features/Home/presentation/home.dart';
import 'package:flutter_application_1/Features/Books/presentation/bloc/bookGroup/bookgroup_cubit.dart';
import 'package:flutter_application_1/Features/Settings/presentation/bloc/setting_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        // BlocProvider(
        //   create: (context) => BookgroupCubit(),
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeApp.lightTheme,
        home: const HomePage(),
      ),
    );
  }
}
