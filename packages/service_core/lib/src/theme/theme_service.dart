import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_base/utils/light_model.dart'; // lightKV
import 'package:lib_base/theme/app_colors.dart';

class ThemeService extends GetxService {
  static ThemeService get to => Get.find();

  final _key = 'theme_mode';

  // Default to system
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedTheme = await lightKV.getString(key: _key);
    if (savedTheme == 'light') {
      themeMode.value = ThemeMode.light;
    } else if (savedTheme == 'dark') {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.system;
    }
    _updateTheme(themeMode.value);
  }

  void setTheme(ThemeMode mode) {
    themeMode.value = mode;
    String saveValue = 'system';
    if (mode == ThemeMode.light) saveValue = 'light';
    if (mode == ThemeMode.dark) saveValue = 'dark';

    lightKV.setString(_key, saveValue);
    _updateTheme(mode);
  }

  void _updateTheme(ThemeMode mode) {
    Get.changeThemeMode(mode);
  }

  bool get isDarkMode {
    if (themeMode.value == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    }
    return themeMode.value == ThemeMode.dark;
  }
}
