import 'package:flutter/material.dart';

/// Manages all app dimensions.
@immutable
class AppDimensions {
  static final double screenHeight =
      MediaQueryData.fromView(WidgetsBinding.instance.window).size.height;
  static final double screenWidth =
      MediaQueryData.fromView(WidgetsBinding.instance.window).size.width;

  static const double defaultPadding = 8.0;
  static const double padding1 = 18.0;
  static const double padding2 = 20.0;

  static const double borderRadius1 = 40;

  static final double childAspectRatio =
      (screenWidth / 2) / (screenHeight / 8);

  static final double height1 = screenHeight * 0.1;
}
