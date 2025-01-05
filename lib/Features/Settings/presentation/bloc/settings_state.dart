import 'package:flutter/material.dart';

class SettingsState {
  final String selectedTheme;
  final double fontSize;
  final double lineSpacing;
  final String selectedFont;
  final Color selectedBackgroundColor;
  final String pageOrientation;
  final Axis axix;
  final bool isLightMode;
  final List<Color> backgroundPageColor;
  final Color selectedPageColor;

  SettingsState(
      {this.backgroundPageColor = const [
        Color(0xFF242323),
        Color.fromRGBO(255, 236, 179, 1),
        Color(0xFFFFFFFF),
      ],
      this.selectedPageColor = const Color.fromARGB(255, 255, 255, 255),
      this.selectedTheme = 'روشن',
      this.fontSize = 14,
      this.lineSpacing = 1.5,
      this.selectedFont = 'بهیج',
      this.selectedBackgroundColor = const Color.fromRGBO(141, 110, 99, 1),
      this.pageOrientation = 'عمودی',
      this.axix = Axis.vertical,
      this.isLightMode = true});

  SettingsState copyWith(
      {String? selectedTheme,
      double? fontSize,
      double? lineSpacing,
      String? selectedFont,
      Color? selectedBackgroundColor,
      String? pageOrientation,
      Axis? axix,
      bool? isLightMode,
      Color? selectedPageColor}) {
    return SettingsState(
        selectedTheme: selectedTheme ?? this.selectedTheme,
        fontSize: fontSize ?? this.fontSize,
        lineSpacing: lineSpacing ?? this.lineSpacing,
        selectedFont: selectedFont ?? this.selectedFont,
        selectedBackgroundColor:
            selectedBackgroundColor ?? this.selectedBackgroundColor,
        pageOrientation: pageOrientation ?? this.pageOrientation,
        axix: axix ?? this.axix,
        isLightMode: isLightMode ?? this.isLightMode,
        selectedPageColor: selectedPageColor ?? this.selectedPageColor);
  }
}
