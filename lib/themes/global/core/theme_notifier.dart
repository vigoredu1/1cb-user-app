import 'package:flutter/cupertino.dart';

class ThemeNotifier {
  static ValueNotifier<String> themeValue = ValueNotifier("fuzzy");

  static void update(String theme) {
    themeValue.value = theme;
  }
}
