import 'package:flutter/material.dart';

extension LocaleExtension on Locale {
  String toHttpLanguageCode() {
    if (countryCode != null && countryCode!.isNotEmpty) {
      return '${languageCode}_$countryCode';
    }
    return languageCode;
  }
}
