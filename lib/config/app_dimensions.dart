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
  static const double padding3 = 4.0;
  static const double padding4 = 34.0;

  static const double borderRadius1 = 40;

  static final double childAspectRatio =
      (screenWidth / 2) / (screenHeight / 5);

  static final double height1 = screenHeight * 0.1;
  static final double height2 = screenHeight * 0.25;

  static final double width1 = AppDimensions.screenWidth * 0.4;
  static final double width2 = AppDimensions.screenWidth * 0.8;

  static const double fontSize1 = 20;
}
