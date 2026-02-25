import 'package:flutter/material.dart';

class BetaTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      primary: Colors.indigo,
      secondary: Colors.tealAccent,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(centerTitle: false, elevation: 4),
  );
}
