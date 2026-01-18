import 'package:feat_main/main_router.dart';
import 'package:feat_onboarding/onboarding_router.dart';
import 'package:feat_splash/splash_router.dart';
import 'package:feat_ui_sample/ui_sample_router.dart';
import 'package:service_router/router_path.dart';
import 'package:get/get.dart';

class AppRouter {
  static List<GetPage> getAllRoutS() {
    return [
      ...MainRouter.routers,
      ...UiSampleRouter.routers,
      ...SplashRouter.routers,
      ...OnboardingRouter.routers,
    ];
  }

  static configNormalRouts() {
    return RouterPath.splash;
  }
}
