import 'package:get/get.dart';
import 'communication_demo_controller.dart';

class CommunicationDemoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommunicationDemoController());
  }
}
