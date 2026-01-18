import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_router/service_router.dart';
import '../theme/theme_service.dart';
import '../i18n/language_service.dart';

class ConfigService extends GetxService implements IConfigService {
  final RxString _currency = 'USD'.obs;

  // Inject dependencies (now internal to feat_core)
  ThemeService get _themeService => Get.find<ThemeService>();
  LanguageService get _languageService => Get.find<LanguageService>();

  @override
  String get currency => _currency.value;

  @override
  String get language => _languageService.locale.value.toString();

  @override
  bool get isDarkMode => _themeService.isDarkMode;

  @override
  Future<void> setCurrency(String currency) async {
    _currency.value = currency;
    // TODO: Persist currency
  }

  @override
  Future<void> setLanguage(String language) async {
    // Parse language string (e.g. "en_US")
    final parts = language.split('_');
    if (parts.length == 2) {
      _languageService.setLocale(Locale(parts[0], parts[1]));
    }
  }

  @override
  Future<void> toggleTheme() async {
    final current = _themeService.themeMode.value;
    if (current == ThemeMode.dark) {
      _themeService.setTheme(ThemeMode.light);
    } else {
      _themeService.setTheme(ThemeMode.dark);
    }
  }
}
