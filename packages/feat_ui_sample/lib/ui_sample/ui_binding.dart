import 'package:feat_ui_sample/ui_sample/ui_controller.dart';
import 'package:get/get.dart';

class UiSampleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UiSampleController());
  }
}
