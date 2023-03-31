import 'package:flutter/material.dart';

/// Manages both Dark and light themes.
@immutable
class AppTheme {
  /// App light theme.
  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
  );

  // TODO: dark theme.
}