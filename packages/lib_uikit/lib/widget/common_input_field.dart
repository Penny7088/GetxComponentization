import 'package:flutter/material.dart';
import 'package:lib_base/utils/extensions/context_extensions.dart';
import 'package:lib_base/widgets/inner_shadow_box.dart';
import 'package:lib_base/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum InputStatus { normal, success, error }

class CommonInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final InputStatus inputStatus;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final VoidCallback? onSuffixTap;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;
  final bool isPassword;

  const CommonInputField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.inputStatus = InputStatus.normal,
    this.errorText,
    this.onChanged,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.onSuffixTap,
    this.focusNode,
    this.autovalidateMode,
    this.isPassword = false,
  });

  @override
  State<CommonInputField> createState() => _CommonInputFieldState();
}

class _CommonInputFieldState extends State<CommonInputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText || widget.isPassword;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorExtension>()!;
    final primaryColor = Theme.of(context).primaryColor;

    Color getBorderColor() {
      switch (widget.inputStatus) {
        case InputStatus.success:
          return appColors.upColor; // 绿色
        case InputStatus.error:
          return appColors.decreaseColor; // 红色
        case InputStatus.normal:
          return appColors.outlineColor; // 默认灰色
      }
    }

    // 根据状态确定右侧图标
    Widget? getSuffixIcon() {
      if (widget.suffixIcon != null) return widget.suffixIcon;

      switch (widget.inputStatus) {
        case InputStatus.success:
          return Icon(Icons.check_circle_outline, color: appColors.upColor);
        case InputStatus.error:
          return GestureDetector(
            onTap: widget.onSuffixTap,
            child: Icon(Icons.cancel_outlined, color: appColors.decreaseColor),
          );
        case InputStatus.normal:
          if (widget.isPassword) {
            return IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: appColors.secondTextColor,
              ),
              onPressed: _toggleVisibility,
            );
          }
          return null;
      }
    }

    final borderColor = getBorderColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor, // 背景色，适配深色模式
            borderRadius: BorderRadius.circular(8.0.r), // 圆角
            boxShadow: [
              if (Theme.of(context).brightness == Brightness.light)
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: InnerShadowBox(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black.withOpacity(0.05)
                : Colors.transparent,
            blurRadius: 4,
            offset: const Offset(0, 2),
            borderRadius: BorderRadius.circular(8.0.r),
            child: TextFormField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              autovalidateMode: widget.autovalidateMode,
              obscureText: _obscureText,
              keyboardType: widget.keyboardType,
              onChanged: widget.onChanged,
              validator: widget.validator,
              readOnly: widget.readOnly,
              onTap: widget.onTap,
              style: TextStyle(
                color: appColors.mainTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: widget.labelText,
                hintText: widget.hintText,
                prefixIcon: widget.prefixIcon,
                suffixIcon: getSuffixIcon(),
                labelStyle: TextStyle(
                  color: appColors.secondTextColor,
                  fontSize: 14,
                ),
                floatingLabelStyle: TextStyle(
                  color: widget.inputStatus == InputStatus.normal
                      ? primaryColor
                      : borderColor, // Focus时标签颜色
                  fontSize: 12,
                ),
                hintStyle: TextStyle(
                  color: appColors.secondTextColor.withOpacity(0.5),
                  fontSize: 14,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: appColors.outlineColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: borderColor, // 使用状态颜色
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: widget.inputStatus == InputStatus.normal
                        ? primaryColor
                        : borderColor, // 如果是 error/success 状态，Focus 时保持状态颜色
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: appColors.decreaseColor,
                    width: 1.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: appColors.decreaseColor,
                    width: 1.5,
                  ),
                ),

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
        // 如果有额外的错误文本且不在 InputDecoration 中显示（设计稿中错误提示可能在框外，或者框变红）
        // 这里暂时依赖 InputDecoration 的 errorText 或者外部传入的 InputStatus 控制边框
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              widget.errorText!,
              style: TextStyle(color: appColors.decreaseColor, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}
