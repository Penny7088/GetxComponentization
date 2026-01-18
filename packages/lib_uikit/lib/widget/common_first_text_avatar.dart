import 'package:flutter/material.dart';
import 'package:lib_uikit/widget/app_text.dart';

class CommonFirstTextAvatar extends StatelessWidget {
  final String text;
  final double size;
  final double? fontSize;
  final Color? backgroundColor;
  final Color? textColor;
  final BoxShape shape;
  final BorderRadius? borderRadius;

  const CommonFirstTextAvatar({
    super.key,
    required this.text,
    this.size = 40.0,
    this.fontSize,
    this.backgroundColor,
    this.textColor,
    this.shape = BoxShape.circle,
    this.borderRadius,
  });

  String get _initials {
    if (text.isEmpty) return '';
    final parts = text.trim().split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return text.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.primaryColor;
    final txtColor = textColor ?? Colors.white;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? (borderRadius ?? BorderRadius.circular(8))
            : null,
      ),
      child: AppText.mediumBold(_initials, color: txtColor),
    );
  }
}
