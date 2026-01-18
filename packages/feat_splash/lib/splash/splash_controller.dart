import 'package:feat_splash/splash/splash_state.dart';
import 'package:lib_base/getx/controller/common_controller.dart';
import 'package:lib_base/utils/light_model.dart';
import 'package:lib_base/mixin/tab_mixin.dart';
import 'package:service_router/router_path.dart';
import 'package:get/get.dart';

class SplashController extends CommonController<SplashState> with TabMixin {
  static const String _isFirstOpenKey = 'isFirstOpen';

  @override
  void onInit() {
    super.onInit();
  }

  @override
  SplashState createState() {
    return SplashState();
  }

  void onAnimationFinished() async {
    // 检查是否是第一次打开 App
    final isFirstOpen = await lightKV.getBool(_isFirstOpenKey) ?? true;

    if (isFirstOpen) {
      // 如果是第一次打开，记录状态并跳转到 Onboarding
      await lightKV.setBool(_isFirstOpenKey, false);
      Get.offNamed(RouterPath.onboarding);
    } else {
      // 否则直接跳转到主页
      Get.offNamed(RouterPath.main);
    }
  }
}
