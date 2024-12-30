import 'package:flutter/material.dart';
import 'package:flutter_application_1/Features/Settings/presentation/bloc/setting_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomSnackBar {
  static void show(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        showCloseIcon: true,
        closeIconColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(4),
        elevation: 6,
        backgroundColor: BlocProvider.of<SettingsCubit>(context)
            .state
            .selectedBackgroundColor
            .withOpacity(0.74),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Text(textDirection: TextDirection.rtl, message)));
  }
}
