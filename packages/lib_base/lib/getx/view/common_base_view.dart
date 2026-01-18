import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../enum/page_state.dart';
import '../controller/common_controller.dart';
import 'mixin/appbar_mixin.dart';
import 'mixin/view_mixin.dart';

abstract class CommonBaseView<C extends CommonController> extends GetView<C>
    with ViewMixin, AppBarMixin {
  const CommonBaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<C>(
      builder: (controller) {
        return createScaffoldWidget(context: context);
      },
    );
  }

  @override
  Widget? createScaffoldBottomNavigationBar({
    required BuildContext context,
    BoxConstraints? constraints,
  }) {
    return null;
  }

  @override
  Widget? createLoadingWidget() {
    return null;
  }

  @override
  Widget? createEmptyWidget() {
    return const Center(child: Text("No Data"));
  }

  /// UI配置项
  /// ---------------- 脚手架配置项 ---------------- ///
  /// 是否使用脚手架
  @override
  bool configIsNeedScaffold() {
    return controller.state.isNeedScaffold;
  }

  ///是否形变
  @override
  bool? configResizeToAvoidBottomInset() {
    return controller.state.resizeToAvoidBottomInset;
  }

  /// 脚手架背景颜色
  @override
  Color? configScaffoldBackgroundColor(BuildContext context) {
    return controller.state.scaffoldBackGroundColor ??
        Theme.of(context).scaffoldBackgroundColor;
  }

  @override
  bool configIsNeedBottomNavigation() {
    return controller.state.isShowBottomBar;
  }

  @override
  void leadingCallback({BuildContext? context}) {
    controller.tapNormalBack();
  }

  /// ---------------- AppBar配置项 ---------------- ///

  /// 配置导航栏背景视图
  @override
  Widget? createFlexBleSpace() {
    return null;
  }

  /// ---------------- 安全区域配置项 ---------------- ///
  /// 是否需要 安全区域 控件
  @override
  bool configIsNeedSafeArea() {
    return controller.state.isNeedScaffold;
  }

  /// 是否关闭顶部安全区域
  @override
  bool configSafeAreaTop() {
    return controller.state.safeAreaTop;
  }

  /// 是否关闭底部安全区域
  @override
  bool configSafeAreaBottom() {
    return controller.state.safeAreaBottom;
  }

  /// ---------------- 界面通用配置项 ---------------- ///
  /// 是否显示加载动画
  @override
  bool isShowLoading() {
    return controller.state.isShowLoading;
  }

  /// 配置界面状态值
  @override
  PageState configPageState() {
    return controller.state.pageState;
  }
}
