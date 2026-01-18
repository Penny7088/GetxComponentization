import 'package:get/get.dart';
import 'package:service_router/service_router.dart';
import 'package:lib_base/lib_base.dart';
import '../auth/auth_service.dart';
import '../config/config_service.dart';
import '../socket/socket_service.dart';
import '../theme/theme_service.dart';
import '../i18n/language_service.dart';

class CoreBinding extends Bindings {
  @override
  void dependencies() {
    // 基础 UI 服务 (Theme, Language) - 移动到 Core 中管理
    Get.put<ThemeService>(ThemeService(), permanent: true);
    Get.put<LanguageService>(LanguageService(), permanent: true);

    // 注入实现到接口
    Get.put<IUserService>(AuthService(), permanent: true);
    Get.put<IConfigService>(ConfigService(), permanent: true);

    // 注入 SocketService
    Get.putAsync<SocketService>(() async {
      final service = SocketService();
      return service;
    }, permanent: true);
  }
}
