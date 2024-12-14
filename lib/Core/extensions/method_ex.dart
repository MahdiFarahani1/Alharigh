// import 'package:flutter/material.dart';

extension MethodEx on String {
  String fixTitle() {
    if (length > 10) {
      String sub = this..substring(10);
      String newValue = "$sub ...";
      return newValue;
    }
    return this;
  }
}

extension BookTitleExtension on Map<String, dynamic> {
  String get formattedTitleWithJoz {
    bool havePart = this['joz'] != 0;
    return havePart
        ? '${this['title']} الجزء ${this['joz']}'
        : '${this['title']}';
  }
}
