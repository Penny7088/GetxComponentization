import 'package:flutter/material.dart';import 'dart:ui';
import 'package:get/get.dart';
import 'package:lib_base/utils/light_model.dart'; // lightKV

class LanguageService extends GetxService {
  static LanguageService get to => Get.find();

  final _key = 'language_locale';

  Rx<Locale> locale = const Locale('zh', 'CN').obs;

  @override
  void onInit() {
    super.onInit();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final savedLocale = await lightKV.getString(key: _key);
    if (savedLocale != null && savedLocale.isNotEmpty) {
      final parts = savedLocale.split('_');
      if (parts.length == 2) {
        locale.value = Locale(parts[0], parts[1]);
      }
    }
    _updateLocale(locale.value);
  }

  void setLocale(Locale newLocale) {
    locale.value = newLocale;
    String saveValue = '${newLocale.languageCode}_${newLocale.countryCode}';
    lightKV.setString(_key, saveValue);
    _updateLocale(newLocale);
  }

  void _updateLocale(Locale newLocale) {
    Get.updateLocale(newLocale);
  }
}
