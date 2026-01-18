import 'package:flutter/material.dart';
import 'package:lib_base/utils/extensions/context_extensions.dart';
import 'package:lib_base/theme/app_colors.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lib_base/widgets/inner_shadow_box.dart';

class CommonVerificationCode extends StatelessWidget {
  final int length;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final bool autofocus;

  const CommonVerificationCode({
    super.key,
    this.length = 6,
    this.controller,
    this.focusNode,
    this.onCompleted,
    this.onChanged,
    this.errorText,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorExtension>()!;
    final primaryColor = Theme.of(context).primaryColor;
    final isLight = Theme.of(context).brightness == Brightness.light;

    // 基础装饰（背景、圆角、边框）
    final baseDecoration = BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(8.r),
      border: Border.all(color: appColors.outlineColor),
    );

    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 50.w,
      textStyle: TextStyle(
        fontSize: 24.sp,
        color: appColors.mainTextColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: baseDecoration.copyWith(
        boxShadow: [
          if (isLight)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 4,
              // inset: true, // Removed
            ),
        ],
      ),
    );

    // 聚焦/已输入状态
    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: baseDecoration.copyWith(
        border: Border.all(color: primaryColor, width: 2),
        boxShadow: [],
      ),
    );

    // 错误状态
    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: baseDecoration.copyWith(
        border: Border.all(color: appColors.decreaseColor),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Pinput(
          length: length,
          controller: controller,
          focusNode: focusNode,
          autofocus: autofocus,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: focusedPinTheme,
          errorPinTheme: errorPinTheme,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          showCursor: true,
          onCompleted: onCompleted,
          onChanged: onChanged,
          forceErrorState: errorText != null,
          errorText: errorText,
          errorTextStyle: TextStyle(
            color: appColors.decreaseColor,
            fontSize: 12.sp,
          ),
          cursor: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 9),
                width: 22,
                height: 1,
                color: primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
