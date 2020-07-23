import 'package:flutter/material.dart';

class Themes {
  //static const DEFAULT_THEME_CODE = 0;

  static final _default = ThemeData(
      primaryColor: Colors.blue,
      secondaryHeaderColor: Colors.red,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.grey[700]),
      accentColor: Colors.blue,
      canvasColor: Colors.black,
      textTheme: TextTheme(
        title: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        subtitle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        display1: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
      disabledColor: Colors.blue);

  static ThemeData getTheme(int code) {
    return _default;
  }
}
