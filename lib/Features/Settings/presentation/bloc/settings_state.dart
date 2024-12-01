import 'package:flutter/material.dart';

class SettingsState {
  final String selectedTheme;
  final double fontSize;
  final double lineSpacing;
  final String selectedFont;
  final Color selectedBackgroundColor;
  final String pageOrientation;
  final Axis axix;

  SettingsState(
      {this.selectedTheme = 'روشن',
      this.fontSize = 14,
      this.lineSpacing = 1.5,
      this.selectedFont = 'بهیج',
      this.selectedBackgroundColor = Colors.white,
      this.pageOrientation = 'عمودی',
      this.axix = Axis.horizontal});

  SettingsState copyWith({
    String? selectedTheme,
    double? fontSize,
    double? lineSpacing,
    String? selectedFont,
    Color? selectedBackgroundColor,
    String? pageOrientation,
    Axis? axix,
  }) {
    return SettingsState(
      selectedTheme: selectedTheme ?? this.selectedTheme,
      fontSize: fontSize ?? this.fontSize,
      lineSpacing: lineSpacing ?? this.lineSpacing,
      selectedFont: selectedFont ?? this.selectedFont,
      selectedBackgroundColor:
          selectedBackgroundColor ?? this.selectedBackgroundColor,
      pageOrientation: pageOrientation ?? this.pageOrientation,
      axix: axix ?? this.axix,
    );
  }
}
