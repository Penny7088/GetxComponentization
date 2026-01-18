import 'package:get/get.dart';
import 'package:service_router/service_router.dart';
import 'package:feat_main/main_container/main_container_binding.dart';
import 'package:feat_main/main_container/main_container_page.dart';

class MainRouter {
  static List<GetPage> routers = [
    GetPage(
      name: RouterPath.main,
      page: () => const MainContainerPage(),
      binding: MainContainerBinding(),
    ),
  ];
}
