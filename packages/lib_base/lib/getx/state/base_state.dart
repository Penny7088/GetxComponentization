import 'package:flutter/material.dart';

import '../../enum/page_state.dart';

class BaseState {
  PageState pageState;
  String? mark;
  String? msg;

  // UI 配置
  bool isShowAppBar = true;
  String appBarTitle = '';
  Color? navBackgroundColor;
  bool safeAreaTop = true;
  bool safeAreaBottom = false;
  bool isShowBottomBar = false;

  /// 背景颜色，如果为 null 则使用主题背景色 (Theme.of(context).scaffoldBackgroundColor)
  Color? scaffoldBackGroundColor;
  bool isNeedScaffold = true;
  bool? resizeToAvoidBottomInset;
  bool isShowLoading = false;

  BaseState({this.pageState = PageState.initializedState});

  /// 释放资源（可选覆盖）
  void release() {}
}
