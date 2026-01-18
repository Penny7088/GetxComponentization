import 'package:flutter/material.dart';
import 'package:lib_base/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ButtonType { primary, outline, text, destructive }

enum ButtonIconPosition { left, right, top, bottom }

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final double? width;
  final double? height;
  final bool isLoading;
  final Widget? icon;
  final ButtonIconPosition iconPosition;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;

  const CommonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.width,
    this.height,
    this.isLoading = false,
    this.icon,
    this.iconPosition = ButtonIconPosition.left,
    this.borderRadius = 8.0,
    this.backgroundColor,
    this.textColor,
  });

  factory CommonButton.primary({
    required String text,
    VoidCallback? onPressed,
    double? width,
    double? height,
    bool isLoading = false,
    Widget? icon,
    ButtonIconPosition iconPosition = ButtonIconPosition.left,
    double borderRadius = 8.0,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return CommonButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.primary,
      width: width,
      height: height,
      isLoading: isLoading,
      icon: icon,
      iconPosition: iconPosition,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  factory CommonButton.outline({
    required String text,
    VoidCallback? onPressed,
    double? width,
    double? height,
    bool isLoading = false,
    Widget? icon,
    ButtonIconPosition iconPosition = ButtonIconPosition.left,
    double borderRadius = 8.0,
  }) {
    return CommonButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.outline,
      width: width,
      height: height,
      isLoading: isLoading,
      icon: icon,
      iconPosition: iconPosition,
      borderRadius: borderRadius,
    );
  }

  factory CommonButton.text({
    required String text,
    VoidCallback? onPressed,
    double? width,
    double? height,
    bool isLoading = false,
    Widget? icon,
    ButtonIconPosition iconPosition = ButtonIconPosition.left,
    double borderRadius = 8.0,
    Color? textColor,
  }) {
    return CommonButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.text,
      width: width,
      height: height,
      isLoading: isLoading,
      icon: icon,
      iconPosition: iconPosition,
      borderRadius: borderRadius,
      textColor: textColor,
    );
  }

  factory CommonButton.destructive({
    required String text,
    VoidCallback? onPressed,
    double? width,
    double? height,
    bool isLoading = false,
    Widget? icon,
    ButtonIconPosition iconPosition = ButtonIconPosition.left,
    double borderRadius = 8.0,
  }) {
    return CommonButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.destructive,
      width: width,
      height: height,
      isLoading: isLoading,
      icon: icon,
      iconPosition: iconPosition,
      borderRadius: borderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorExtension>()!;
    final primaryColor = Theme.of(context).primaryColor;
    final isEnabled = onPressed != null && !isLoading;

    // 默认高度 50
    final btnHeight = height ?? 50.h;
    // 默认宽度撑满
    final btnWidth = width ?? double.infinity;

    Color getBackgroundColor() {
      if (!isEnabled && type != ButtonType.text) {
        return appColors.outlineColor.withOpacity(0.3); // Disabled color
      }
      if (backgroundColor != null) return backgroundColor!;

      switch (type) {
        case ButtonType.primary:
          return primaryColor;
        case ButtonType.destructive:
          return appColors.decreaseColor;
        case ButtonType.outline:
        case ButtonType.text:
          return Colors.transparent;
      }
    }

    Color getTextColor() {
      if (!isEnabled) {
        return appColors.secondTextColor.withOpacity(0.5);
      }
      if (textColor != null) return textColor!;

      switch (type) {
        case ButtonType.primary:
        case ButtonType.destructive:
          return Colors.white;
        case ButtonType.outline:
          return appColors.mainTextColor;
        case ButtonType.text:
          return primaryColor;
      }
    }

    Color getBorderColor() {
      if (!isEnabled) return Colors.transparent;
      switch (type) {
        case ButtonType.outline:
          return appColors.outlineColor;
        default:
          return Colors.transparent;
      }
    }

    final bgColor = getBackgroundColor();
    final txtColor = getTextColor();
    final borderColor = getBorderColor();

    Widget buildIcon() {
      if (icon == null) return const SizedBox.shrink();
      return IconTheme(
        data: IconThemeData(color: txtColor, size: 20.sp),
        child: icon!,
      );
    }

    Widget buildText() {
      return Text(
        text,
        style: TextStyle(
          color: txtColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    Widget child;

    if (isLoading) {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20.w,
            height: 20.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(txtColor),
            ),
          ),
          SizedBox(width: 8.w),
          buildText(),
        ],
      );
    } else {
      switch (iconPosition) {
        case ButtonIconPosition.left:
          child = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[buildIcon(), SizedBox(width: 8.w)],
              buildText(),
            ],
          );
          break;
        case ButtonIconPosition.right:
          child = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildText(),
              if (icon != null) ...[SizedBox(width: 8.w), buildIcon()],
            ],
          );
          break;
        case ButtonIconPosition.top:
          child = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[buildIcon(), SizedBox(height: 4.h)],
              buildText(),
            ],
          );
          break;
        case ButtonIconPosition.bottom:
          child = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildText(),
              if (icon != null) ...[SizedBox(height: 4.h), buildIcon()],
            ],
          );
          break;
      }
    }

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(borderRadius.r),
      type: MaterialType.button,
      elevation: 0,
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: BorderRadius.circular(borderRadius.r),
        child: Container(
          width: btnWidth,
          height: btnHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius.r),
            border: type == ButtonType.outline
                ? Border.all(color: borderColor, width: 1)
                : null,
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
