import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {
  AppTextStyle._();

  static const String _fontFamily = 'Readex Pro';

  static TextStyle _base({
    required double fontSize,
    required double height,
    required FontWeight fontWeight,
  }) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: fontSize.sp,
      height: height / fontSize,
      fontWeight: fontWeight,
      decoration: TextDecoration.none,
    );
  }

  /// Heading 32/38 Bold
  static TextStyle get heading =>
      _base(fontSize: 32, height: 38, fontWeight: FontWeight.bold);

  /// large Bold - 18/20 Medium
  static TextStyle get largeBold =>
      _base(fontSize: 18, height: 20, fontWeight: FontWeight.w500);

  /// large - 18/20 Regular
  static TextStyle get large =>
      _base(fontSize: 18, height: 20, fontWeight: FontWeight.w400);

  /// Medium Bold - 16/18 Medium
  static TextStyle get mediumBold =>
      _base(fontSize: 16, height: 18, fontWeight: FontWeight.w500);

  /// Medium - 16/18 Regular
  static TextStyle get medium =>
      _base(fontSize: 16, height: 18, fontWeight: FontWeight.w400);

  /// Small Bold - 14/16 Medium
  static TextStyle get smallBold =>
      _base(fontSize: 14, height: 16, fontWeight: FontWeight.w500);

  /// Small - 14/16 Regular
  static TextStyle get small =>
      _base(fontSize: 14, height: 16, fontWeight: FontWeight.w400);

  /// xSmall Bold - 12/14 Medium
  static TextStyle get xSmallBold =>
      _base(fontSize: 12, height: 14, fontWeight: FontWeight.w500);

  /// xSmall - 12/14 Regular
  static TextStyle get xSmall =>
      _base(fontSize: 12, height: 14, fontWeight: FontWeight.w400);
}
