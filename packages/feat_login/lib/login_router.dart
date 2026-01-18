import 'package:get/get.dart';
// import 'package:service_router/service_router.dart'; // Uncomment when RouterPath is updated
import 'package:feat_login/login/login_binding.dart';
import 'package:feat_login/login/login_page.dart';

class LoginRouter {
  static List<GetPage> routers = [
    GetPage(
      name: '/login', // TODO: Add RouterPath.login in service_router
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
  ];
}
