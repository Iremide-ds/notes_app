import 'package:flutter/material.dart';

/// Manages both Dark and light themes.
@immutable
class AppTheme {
  /// App light theme.
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
    useMaterial3: true,
  );

  // TODO: dark theme.
  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
    useMaterial3: true,
  );
}