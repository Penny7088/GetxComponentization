import 'package:get/get.dart';
import 'package:service_router/service_router.dart';
import 'package:feat_onboarding/onboarding/onboarding_binding.dart';
import 'package:feat_onboarding/onboarding/onboarding_page.dart';

class OnboardingRouter {
  static List<GetPage> routers = [
    GetPage(
      name: RouterPath.onboarding,
      page: () => const OnboardingPage(),
      binding: OnboardingBinding(),
    ),
  ];
}
