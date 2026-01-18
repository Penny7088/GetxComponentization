import 'package:flutter/material.dart';
import 'package:lib_base/theme/app_colors.dart';
import 'package:lib_uikit/theme/dark_color.dart';
import 'package:lib_uikit/theme/light_color.dart';

class AppTheme {
  AppTheme._();

  static final light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: LightColors.primaryColor,
    scaffoldBackgroundColor: LightColors.backgroundColor,
    cardColor: LightColors.surfaceColor,
    dividerColor: LightColors.outlineColor,
    appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
    colorScheme: const ColorScheme.light(
      primary: LightColors.primaryColor,
      secondary: LightColors.primaryColor,
      surface: LightColors.surfaceColor,
      onSurface: LightColors.mainTextColor,
      outline: LightColors.outlineColor,
    ),
    extensions: [
      AppColorExtension(
        mainTextColor: LightColors.mainTextColor,
        secondTextColor: LightColors.secondTextColor,
        upColor: LightColors.upColor,
        fallColor: LightColors.fallColor,
        decreaseColor: LightColors.decreaseColor,
        backgroundColor: LightColors.backgroundColor,
        outlineColor: LightColors.outlineColor,
      ),
    ],
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: DarkColor.primaryColor,
    scaffoldBackgroundColor: DarkColor.backgroundColor,
    cardColor: DarkColor.surfaceColor,
    dividerColor: DarkColor.outlineColor,
    colorScheme: ColorScheme.dark(
      primary: DarkColor.primaryColor,
      secondary: DarkColor.primaryColor,
      surface: DarkColor.surfaceColor,
      onSurface: DarkColor.mainTextColor,
      outline: DarkColor.outlineColor,
    ),
    extensions: [
      AppColorExtension(
        mainTextColor: DarkColor.mainTextColor,
        secondTextColor: DarkColor.secondTextColor,
        upColor: DarkColor.upColor,
        fallColor: DarkColor.fallColor,
        decreaseColor: DarkColor.decreaseColor,
        backgroundColor: DarkColor.backgroundColor,
        outlineColor: DarkColor.outlineColor,
      ),
    ],
  );
}
