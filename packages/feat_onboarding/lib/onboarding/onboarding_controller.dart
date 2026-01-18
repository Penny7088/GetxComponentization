import 'package:feat_onboarding/onboarding/onboarding_state.dart';
import 'package:flutter/material.dart';
import 'package:lib_base/getx/controller/common_controller.dart';
import 'package:service_router/router_path.dart';
import 'package:get/get.dart';

class OnboardingController extends CommonController<OnboardingState> {
  final PageController pageController = PageController();
  final currentPage = 0.obs;

  @override
  OnboardingState createState() {
    return OnboardingState();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void next() {
    if (currentPage.value < state.items.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // 完成引导，跳转到主页或登录页
      Get.offNamed(RouterPath.main);
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
