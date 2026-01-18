import 'dart:ui';

import 'package:feat_main/main_container/main_state.dart';
import 'package:flutter/material.dart';
import 'package:lib_base/getx/controller/common_controller.dart';
import 'package:lib_base/getx/view/mixin/app_life_cycle_abs.dart';
import 'package:get/get.dart';

class MainContainerController extends CommonController<MainContainerState>
    with AppLifeCycleAbs, AppLifeCycleObserver {
  final RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void configAppLifeCycleResumed() {
    print("App Resumed");
  }

  @override
  void configAppLifeCycleInactive() {
    print("App Inactive");
  }

  @override
  void configAppLifeCyclePaused() {
    print("App Paused");
  }

  @override
  void configAppLifeCycleDetached() {
    print("App Detached");
  }

  @override
  MainContainerState createState() {
    return MainContainerState();
  }
}
