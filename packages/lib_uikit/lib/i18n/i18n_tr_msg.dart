import 'package:get/get.dart';
import 'package:lib_uikit/i18n/en_us.dart';
import 'package:lib_uikit/i18n/zh_cn.dart';

class I18TRMessages extends Translations {
  static final Map<String, Map<String, String>> _keys = {
    'en_US': Map.from(enUS),
    'zh_CN': Map.from(zhCN),
  };

  /// 注册模块翻译
  /// [moduleKeys] 格式: {'en_US': {'hello': 'Hello'}, 'zh_CN': {'hello': '你好'}}
  static void register(Map<String, Map<String, String>> moduleKeys) {
    moduleKeys.forEach((lang, values) {
      if (_keys.containsKey(lang)) {
        _keys[lang]?.addAll(values);
      } else {
        _keys[lang] = Map.from(values);
      }
    });
  }

  @override
  Map<String, Map<String, String>> get keys => _keys;
}
