import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/services/predictive_back_event.dart';
import 'package:get/get.dart';

mixin class AppLifeCycleAbs {
  /// app进入前台
  void configAppLifeCycleResumed() {}

  /// app在前台但不响应事件，比如电话，touch id等"
  void configAppLifeCycleInactive() {}

  /// app进入后台
  void configAppLifeCyclePaused() {}

  /// 没有宿主视图但是flutter引擎仍然有效
  void configAppLifeCycleDetached() {}

  /// App 隐藏
  void configAppLifeCycleHidden() {}

  /// 主题变更事件回调
  void configPlatformBrightness() {}

  /// 语言发生改变回调
  void configChangeLocales(List<Locale>? locales) {}
}

/// 只有混入此 Mixin 的 Controller 才会监听生命周期
mixin AppLifeCycleObserver on GetxController, AppLifeCycleAbs
    implements WidgetsBindingObserver {
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        configAppLifeCycleResumed();
        break;
      case AppLifecycleState.inactive:
        configAppLifeCycleInactive();
        break;
      case AppLifecycleState.paused:
        configAppLifeCyclePaused();
        break;
      case AppLifecycleState.detached:
        configAppLifeCycleDetached();
        break;
      case AppLifecycleState.hidden:
        configAppLifeCycleHidden();
        break;
    }
  }

  @override
  void didChangePlatformBrightness() {
    configPlatformBrightness();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    configChangeLocales(locales);
  }

  @override
  void didChangeAccessibilityFeatures() {}

  @override
  void didChangeMetrics() {}

  @override
  void didChangeTextScaleFactor() {}

  @override
  void didHaveMemoryPressure() {}

  @override
  Future<bool> didPopRoute() => Future.value(false);

  @override
  Future<bool> didPushRoute(String route) => Future.value(false);

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) =>
      Future.value(false);

  @override
  void didChangeViewFocus(ViewFocusEvent event) {}

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    return AppExitResponse.exit;
  }

  @override
  void handleCancelBackGesture() {}

  @override
  void handleCommitBackGesture() {}

  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) => false;

  @override
  void handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) {}
}
