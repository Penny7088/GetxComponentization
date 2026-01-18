import 'package:get/get.dart';
import 'package:service_router/service_router.dart';
import 'ui_sample/ui_binding.dart';
import 'ui_sample/ui_container_page.dart';
import 'communication_demo/communication_demo_page.dart';
import 'communication_demo/communication_demo_binding.dart';

class UiSampleRouter {
  static final routers = [
    GetPage(
      name: RouterPath.uiSample,
      page: () => const UiSamplePage(),
      binding: UiSampleBinding(),
    ),
    GetPage(
      name: RouterPath.communicationDemo,
      page: () => const CommunicationDemoPage(),
      binding: CommunicationDemoBinding(),
    ),
  ];
}
