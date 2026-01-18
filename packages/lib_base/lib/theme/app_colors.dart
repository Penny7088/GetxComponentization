import 'package:flutter/material.dart';

@immutable
class AppColorExtension extends ThemeExtension<AppColorExtension> {
  final Color mainTextColor;
  final Color secondTextColor;
  final Color upColor;
  final Color fallColor;
  final Color decreaseColor;
  final Color backgroundColor;
  final Color outlineColor;

  const AppColorExtension({
    required this.mainTextColor,
    required this.secondTextColor,
    required this.upColor,
    required this.fallColor,
    required this.decreaseColor,
    required this.backgroundColor,
    required this.outlineColor,
  });

  @override
  ThemeExtension<AppColorExtension> copyWith({
    Color? mainTextColor,
    Color? secondTextColor,
    Color? upColor,
    Color? fallColor,
    Color? decreaseColor,
    Color? backgroundColor,
    Color? outlineColor,
  }) {
    return AppColorExtension(
      mainTextColor: mainTextColor ?? this.mainTextColor,
      secondTextColor: secondTextColor ?? this.secondTextColor,
      upColor: upColor ?? this.upColor,
      fallColor: fallColor ?? this.fallColor,
      decreaseColor: decreaseColor ?? this.decreaseColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      outlineColor: outlineColor ?? this.outlineColor,
    );
  }

  @override
  ThemeExtension<AppColorExtension> lerp(
    ThemeExtension<AppColorExtension>? other,
    double t,
  ) {
    if (other is! AppColorExtension) {
      return this;
    }
    return AppColorExtension(
      mainTextColor: Color.lerp(mainTextColor, other.mainTextColor, t)!,
      secondTextColor: Color.lerp(secondTextColor, other.secondTextColor, t)!,
      upColor: Color.lerp(upColor, other.upColor, t)!,
      fallColor: Color.lerp(fallColor, other.fallColor, t)!,
      decreaseColor: Color.lerp(decreaseColor, other.decreaseColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      outlineColor: Color.lerp(outlineColor, other.outlineColor, t)!,
    );
  }
}
