import 'package:flutter/material.dart';
import 'package:lib_base/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final double? width;
  final double? height;

  const CommonSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColorExtension>()!;
    final primaryColor = Theme.of(context).primaryColor;

    // 默认尺寸
    final switchWidth = width ?? 50.w;
    final switchHeight = height ?? 30.h;
    final thumbSize = switchHeight - 4.w; // 留出一点边距

    // 颜色配置
    final activeColor = primaryColor;
    final inactiveColor = appColors.outlineColor;
    final thumbColor = Colors.white;

    return GestureDetector(
      onTap: () {
        if (onChanged != null) {
          onChanged!(!value);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: switchWidth,
        height: switchHeight,
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: value ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(switchHeight / 2),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: thumbSize,
                height: thumbSize,
                decoration: BoxDecoration(
                  color: thumbColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
