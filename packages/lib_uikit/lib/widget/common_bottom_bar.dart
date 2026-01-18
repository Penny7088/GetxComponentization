import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:lib_uikit/theme/app_text_style.dart';

class BottomBarItem {
  final String label;
  final Widget icon;
  final Widget activeIcon;

  BottomBarItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

class CommonBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomBarItem> items;

  const CommonBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 83.h, // 标准 iOS TabBar 高度附近
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
            offset: const Offset(0, -1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = currentIndex == index;
          final color = isSelected 
              ? Theme.of(context).primaryColor 
              : const Color(0xFF7D8592); // Unselected Grey

          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24.w,
                  height: 24.w,
                  child: isSelected ? item.activeIcon : item.icon,
                ),
                SizedBox(height: 4.h),
                AppText(
                  item.label,
                  style: isSelected 
                      ? AppTextStyle.xSmallBold.copyWith(color: color, fontSize: 10.sp)
                      : AppTextStyle.xSmall.copyWith(color: color, fontSize: 10.sp),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
