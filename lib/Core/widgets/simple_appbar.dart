import 'package:flutter/material.dart';

class CustomSimpleAppbar {
  static AppBar appbar(BuildContext context, String title) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor:
          Theme.of(context).floatingActionButtonTheme.backgroundColor,
    );
  }
}
