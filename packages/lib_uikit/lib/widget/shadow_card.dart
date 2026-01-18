import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShadowCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? shadowColor;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const ShadowCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.shadowColor,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final defaultShadowColor = Theme.of(context).primaryColor.withOpacity(0.15);

    Widget content = Container(
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 16.r),
        boxShadow: [
          if (isLight || shadowColor != null)
            BoxShadow(
              color: shadowColor ?? defaultShadowColor,
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 0,
            ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }

    return content;
  }
}
