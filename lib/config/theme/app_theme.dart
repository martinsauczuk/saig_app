import 'package:flutter/material.dart';

class AppTheme {

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.green,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
    ),
  );

}