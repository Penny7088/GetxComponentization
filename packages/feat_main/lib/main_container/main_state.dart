import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lib_base/enum/page_state.dart';
import 'package:lib_base/getx/state/base_state.dart';
import 'package:get/get.dart';

class MainContainerState extends BaseState {
  MainContainerState() {
    isNeedScaffold = true;
    isShowAppBar = false; // 主页不需要默认的 AppBar
    isShowBottomBar = true; // 显示底部导航栏
    safeAreaBottom =
        false; // 底部导航栏通常不需要 SafeArea 包裹（因为它是固定的），或者由 BottomBar 内部处理
  }

  @override
  void release() {}
}
