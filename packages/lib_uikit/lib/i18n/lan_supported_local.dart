import 'dart:ui';

import 'package:get/get.dart';

class LanguageSettingSupported {
  static final List<Locale> _supportedLanguages = [
    const Locale('zh', 'CN'),
    const Locale('zh', 'TW'),
    const Locale('en', 'US'),
    const Locale('vi', 'VN'),
  ];

  /// 获取支持的语言列表
  static List<Locale> get supportedLanguages => _supportedLanguages;

  /// 注册新的支持语言
  static void addSupport(Locale locale) {
    if (!_supportedLanguages.contains(locale)) {
      _supportedLanguages.add(locale);
    }
  }

  static Locale fallbackLocale() {
    final deviceLocale = Get.deviceLocale ?? const Locale('zh', 'CN');
    if (_supportedLanguages.contains(deviceLocale)) {
      return deviceLocale;
    } else {
      return const Locale('en', 'US');
    }
  }
}
