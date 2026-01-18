import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lib_base/enum/page_state.dart';
import 'package:lib_base/getx/state/base_state.dart';
import 'package:get/get.dart';

class UiSampleState extends BaseState {
  UiSampleState() {
    isNeedScaffold = true;
  }

  UiSampleState copyWith({
    PageState? pageState,
    bool? isOk,
    String? msg,
    String? mark,
    bool? isShowAppBar,
    String? appBarTitle,
    Color? navBackgroundColor,
    bool? safeAreaTop,
    bool? safeAreaBottom,
    bool? isShowBottomBar,
    Color? scaffoldBackGroundColor,
    bool? isNeedScaffold,
    bool? resizeToAvoidBottomInset,
    bool? isShowLoading,
  }) {
    return UiSampleState()
      ..pageState = pageState ?? this.pageState
      ..isShowAppBar = isShowAppBar ?? this.isShowAppBar
      ..appBarTitle = appBarTitle ?? this.appBarTitle
      ..navBackgroundColor = navBackgroundColor ?? this.navBackgroundColor
      ..safeAreaTop = safeAreaTop ?? this.safeAreaTop
      ..safeAreaBottom = safeAreaBottom ?? this.safeAreaBottom
      ..isShowBottomBar = isShowBottomBar ?? this.isShowBottomBar
      ..scaffoldBackGroundColor =
          scaffoldBackGroundColor ?? this.scaffoldBackGroundColor
      ..isNeedScaffold = isNeedScaffold ?? this.isNeedScaffold
      ..resizeToAvoidBottomInset =
          resizeToAvoidBottomInset ?? this.resizeToAvoidBottomInset
      ..isShowLoading = isShowLoading ?? this.isShowLoading;
  }

  @override
  void release() {
    // Release resources if any
  }
}
