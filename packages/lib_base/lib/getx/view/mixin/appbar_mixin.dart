import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/common_controller.dart';
import '../appbar_generator.dart';

/// 导航栏
mixin AppBarMixin {
  /// 创建导航栏
  PreferredSizeWidget? createAppBar({required BuildContext context}) {
    if (configIsShowAppBar()) {
      return AppBarGenerator.getNormalAppBar(
        context: context,
        title: createAppBarTitleStr() ?? "",
        backgroundColor: createAppBarNavBackColor(),
        actions: createAppBarActions(),
        leading: createAppBarLeading(),
        textColor: createAppBarTextColor(),
        flexibleSpace: createFlexBleSpace(),
        leadingIconColor: createLeadingIconColor(),
        icon: createLeadIcon(),
        leadingCallback: () {
          leadingCallback(context: context);
        },
        showBack: isShowBack(),
        titleView: createAppBarTitleWidget(),
        bottom: createAppBarBottomWidget(),
        toolbarHeight: toolBarHeight(),
      );
    }
    return null;
  }

  /// 是否需要导航栏
  bool configIsShowAppBar() {
    // 默认从状态读取
    final c = (this as dynamic).controller as CommonController;
    return c.state.isShowAppBar;
  }

  /// 配置导航栏背景颜色
  Color? createAppBarNavBackColor() {
    final c = (this as dynamic).controller as CommonController;
    return c.state.navBackgroundColor;
  }

  /// 配置导航栏字体
  String? createAppBarTitleStr() {
    final c = (this as dynamic).controller as CommonController;
    return c.state.appBarTitle;
  }

  /// 配置返回按钮iconData
  IconData? createLeadIcon() {
    return null;
  }

  /// 自定义appBar title
  Widget? createAppBarTitleWidget() {
    return null;
  }

  /// 设置系统返回按钮 icon 颜色
  Color? createLeadingIconColor() {
    return null;
  }

  /// 设置默认 title 字体颜色
  Color? createAppBarTextColor() {
    return null;
  }

  /// 创建导航栏 右边按钮集合
  List<Widget>? createAppBarActions() {
    return null;
  }

  /// 重写返回按钮控件
  Widget? createAppBarLeading() {
    return null;
  }

  /// 配置导航栏背景
  Widget? createFlexBleSpace() {
    return null;
  }

  /// 配置AppBar bottom
  PreferredSizeWidget? createAppBarBottomWidget() {
    return null;
  }

  /// 是否显示返回按钮
  bool isShowBack() {
    return true;
  }

  /// 配置appBar 高度
  double? toolBarHeight() {
    return null;
  }

  @protected
  void leadingCallback({BuildContext? context});
}
