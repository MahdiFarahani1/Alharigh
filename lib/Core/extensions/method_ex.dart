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
