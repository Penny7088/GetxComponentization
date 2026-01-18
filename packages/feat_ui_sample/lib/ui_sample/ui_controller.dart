import 'package:feat_ui_sample/ui_sample/ui_state.dart';
import 'package:lib_base/getx/controller/common_controller.dart';
import 'package:lib_uikit/widget/common_input_field.dart';
import 'package:get/get.dart';

class UiSampleController extends CommonController<UiSampleState> {
  final emailStatus = InputStatus.normal.obs;
  final isLoading = false.obs;
  final isSwitchOn = false.obs;

  @override
  void onInit() {
    super.onInit();
    state.appBarTitle = "Main Container";
  }

  Future<void> simulateLoading() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      emailStatus.value = InputStatus.normal;
    } else if (val.isEmail) {
      emailStatus.value = InputStatus.success;
    } else {
      emailStatus.value = InputStatus.error;
    }
  }

  @override
  UiSampleState createState() {
    return UiSampleState();
  }
}
