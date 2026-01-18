import 'package:get/get.dart';
import 'package:service_router/service_router.dart';
import 'package:feat_splash/splash/splash_binding.dart';
import 'package:feat_splash/splash/splash_page.dart';

class SplashRouter {
  static List<GetPage> routers = [
    GetPage(
      name: RouterPath.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
  ];
}
