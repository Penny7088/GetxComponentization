import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lib_base/utils/extensions/context_extensions.dart';
import 'package:lib_uikit/theme/app_text_style.dart';
import 'package:lib_base/theme/app_colors.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final double? minFontSize;
  final double? maxFontSize;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const AppText(
    this.text, {
    super.key,
    this.style,
    this.maxLines = 1,
    this.minFontSize = 8,
    this.maxFontSize = double.infinity,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign,
  });

  /// Heading 32/38 Bold
  factory AppText.heading(
    String text, {
    Key? key,
    int? maxLines,
    double? minFontSize,
    TextOverflow? overflow,
    TextAlign? textAlign,
    Color? color,
    double? fontSize,
  }) {
    TextStyle textStyle = AppTextStyle.heading.copyWith(color: color);
    if (fontSize != null) {
      textStyle = textStyle.copyWith(fontSize: fontSize);
    }
    return AppText(
      text,
      key: key,
      style: textStyle,
      maxLines: maxLines ?? 1,
      minFontSize: minFontSize ?? 8,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  /// large Bold - 18/20 Medium
  factory AppText.largeBold(
    String text, {
    Key? key,
    int? maxLines,
    double? minFontSize,
    TextOverflow? overflow,
    TextAlign? textAlign,
    Color? color,
  }) {
    return AppText(
      text,
      key: key,
      style: AppTextStyle.largeBold.copyWith(color: color),
      maxLines: maxLines ?? 1,
      minFontSize: minFontSize ?? 8,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  /// large - 18/20 Regular
  factory AppText.large(
    String text, {
    Key? key,
    int? maxLines,
    double? minFontSize,
    TextOverflow? overflow,
    TextAlign? textAlign,
    Color? color,
  }) {
    return AppText(
      text,
      key: key,
      style: AppTextStyle.large.copyWith(color: color),
      maxLines: maxLines ?? 1,
      minFontSize: minFontSize ?? 8,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  /// Medium Bold - 16/18 Medium
  factory AppText.mediumBold(
    String text, {
    Key? key,
    int? maxLines,
    double? minFontSize,
    TextOverflow? overflow,
    TextAlign? textAlign,
    Color? color,
  }) {
    return AppText(
      text,
      key: key,
      style: AppTextStyle.mediumBold.copyWith(color: color),
      maxLines: maxLines ?? 1,
      minFontSize: minFontSize ?? 8,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  /// Medium - 16/18 Regular
  factory AppText.medium(
    String text, {
    Key? key,
    int? maxLines,
    double? minFontSize,
    TextOverflow? overflow,
    TextAlign? textAlign,
    Color? color,
  }) {
    return AppText(
      text,
      key: key,
      style: AppTextStyle.medium.copyWith(color: color),
      maxLines: maxLines ?? 1,
      minFontSize: minFontSize ?? 8,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  /// Small Bold - 14/16 Medium
  factory AppText.smallBold(
    String text, {
    Key? key,
    int? maxLines,
    double? minFontSize,
    TextOverflow? overflow,
    TextAlign? textAlign,
    Color? color,
  }) {
    return AppText(
      text,
      key: key,
      style: AppTextStyle.smallBold.copyWith(color: color),
      maxLines: maxLines ?? 1,
      minFontSize: minFontSize ?? 8,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  /// Small - 14/16 Regular
  factory AppText.small(
    String text, {
    Key? key,
    int? maxLines,
    double? minFontSize,
    TextOverflow? overflow,
    TextAlign? textAlign,
    Color? color,
  }) {
    return AppText(
      text,
      key: key,
      style: AppTextStyle.small.copyWith(color: color),
      maxLines: maxLines ?? 1,
      minFontSize: minFontSize ?? 8,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  /// xSmall Bold - 12/14 Medium
  factory AppText.xSmallBold(
    String text, {
    Key? key,
    int? maxLines,
    double? minFontSize,
    TextOverflow? overflow,
    TextAlign? textAlign,
    Color? color,
  }) {
    return AppText(
      text,
      key: key,
      style: AppTextStyle.xSmallBold.copyWith(color: color),
      maxLines: maxLines ?? 1,
      minFontSize: minFontSize ?? 8,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  /// xSmall - 12/14 Regular
  factory AppText.xSmall(
    String text, {
    Key? key,
    int? maxLines,
    double? minFontSize,
    TextOverflow? overflow,
    TextAlign? textAlign,
    Color? color,
    double? fontSize,
  }) {
    TextStyle textStyle = AppTextStyle.xSmall.copyWith(color: color);
    if (fontSize != null) {
      textStyle = textStyle.copyWith(fontSize: fontSize);
    }
    return AppText(
      text,
      key: key,
      style: textStyle,
      maxLines: maxLines ?? 1,
      minFontSize: minFontSize ?? 8,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? effectiveStyle = style;
    if (effectiveStyle != null && effectiveStyle.color == null) {
      final appColors = context.appColorExt;
      if (appColors != null) {
        effectiveStyle = effectiveStyle.copyWith(
          color: appColors.mainTextColor,
        );
      }
    }

    return AutoSizeText(
      text,
      style: effectiveStyle,
      maxLines: maxLines,
      minFontSize: minFontSize ?? 8,
      stepGranularity: 0.1, // Allow finer grained resizing
      maxFontSize: maxFontSize ?? double.infinity,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
