/// 全局配置服务接口
/// 定义了跨模块访问配置状态的能力
abstract class IConfigService {
  String get currency;
  String get language;
  bool get isDarkMode;
  
  Future<void> setCurrency(String currency);
  Future<void> setLanguage(String language);
  Future<void> toggleTheme();
}
