import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CustomIcon {
  static Widget iconItem(BuildContext context,
      {required IconData icon,
      required Function onTap,
      Color color = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ZoomTapAnimation(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color:
                  Theme.of(context).floatingActionButtonTheme.backgroundColor),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
