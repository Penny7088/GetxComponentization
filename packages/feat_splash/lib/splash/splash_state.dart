import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lib_base/enum/page_state.dart';
import 'package:lib_base/getx/state/base_state.dart';
import 'package:get/get.dart';

class SplashState extends BaseState {
  SplashState() {
    isNeedScaffold = true;
    isShowAppBar = false; // 隐藏AppBar
    safeAreaTop = false; // 允许内容延伸到顶部状态栏
    safeAreaBottom = false; // 允许内容延伸到底部
  }

  @override
  void release() {
    // Release resources if any
  }
}
