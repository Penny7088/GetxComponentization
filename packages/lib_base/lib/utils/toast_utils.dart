import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_base/theme/app_colors.dart';

class ToastUtils {
  ToastUtils._();

  /// 简单的 Toast 提示 (底部悬浮，无标题)
  static void toast(
    String msg, {
    int duration = 2000,
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    Get.snackbar(
      '',
      msg,
      titleText: Container(),
      messageText: Text(
        msg,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        textAlign: TextAlign.center,
      ),
      snackPosition: position,
      backgroundColor: Colors.black.withOpacity(0.8),
      borderRadius: 8,
      margin: const EdgeInsets.all(20),
      duration: Duration(milliseconds: duration),
      barBlur: 0,
      overlayBlur: 0,
      snackStyle: SnackStyle.FLOATING,
      maxWidth: 300,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  /// 成功提示
  static void success(String msg, {String title = 'Success'}) {
    _show(
      title: title,
      message: msg,
      icon: Icons.check_circle_outline,
      type: _ToastType.success,
    );
  }

  /// 错误提示
  static void error(String msg, {String title = 'Error'}) {
    _show(
      title: title,
      message: msg,
      icon: Icons.cancel_outlined,
      type: _ToastType.error,
    );
  }

  /// 警告提示
  static void warning(String msg, {String title = 'Warning'}) {
    _show(
      title: title,
      message: msg,
      icon: Icons.warning_amber_rounded,
      type: _ToastType.warning,
    );
  }

  /// 信息提示
  static void info(String msg, {String title = 'Info'}) {
    _show(
      title: title,
      message: msg,
      icon: Icons.info_outline,
      type: _ToastType.info,
    );
  }

  static void _show({
    required String title,
    required String message,
    required IconData icon,
    required _ToastType type,
  }) {
    final context = Get.context;
    if (context == null) return;

    final theme = Theme.of(context);
    final appColors = theme.extension<AppColorExtension>();

    Color backgroundColor;
    Color iconColor;
    Color textColor = theme.colorScheme.onSurface;

    // 根据类型获取颜色
    switch (type) {
      case _ToastType.success:
        backgroundColor = appColors?.upColor ?? Colors.green;
        iconColor = Colors.white;
        textColor = Colors.white;
        break;
      case _ToastType.error:
        backgroundColor = appColors?.decreaseColor ?? Colors.red;
        iconColor = Colors.white;
        textColor = Colors.white;
        break;
      case _ToastType.warning:
        backgroundColor = appColors?.fallColor ?? Colors.orange;
        iconColor = Colors.white;
        textColor = Colors.white;
        break;
      case _ToastType.info:
      default:
        backgroundColor = theme.primaryColor;
        iconColor = Colors.white;
        textColor = Colors.white;
        break;
    }

    Get.snackbar(
      title,
      message,
      icon: Icon(icon, color: iconColor, size: 28),
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      borderRadius: 8,
      margin: const EdgeInsets.all(16),
      colorText: textColor,
      duration: const Duration(milliseconds: 2500),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}

enum _ToastType {
  success,
  error,
  warning,
  info,
}
