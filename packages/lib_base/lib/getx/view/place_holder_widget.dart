import 'package:flutter/material.dart';

import '../../enum/page_state.dart';
import '../state/base_state.dart';

class PlaceHolderConfig {
  static Widget? loadWidget;
}

class PlaceHolderWidget extends StatelessWidget {
  // 网络请求状态
  final PageState pageState;
  // 子视图
  final Widget? child;

  /// 加载动画
  final Widget? loadingWidget;
  // 站位图
  final Widget? errorWidget;
  // 是否显示加载动画
  final bool? isShowLoading;
  const PlaceHolderWidget({
    super.key,
    required this.pageState,
    this.child,
    this.errorWidget,
    this.loadingWidget,
    this.isShowLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isError =
        pageState == PageState.errorState ||
        pageState == PageState.errorShowRefresh ||
        pageState == PageState.emptyDataState;
    final showLoading =
        isShowLoading == true && pageState == PageState.initializedState;
    final index = isError ? 0 : (showLoading ? 1 : 2);
    Widget current = isError
        ? (errorWidget ?? Container())
        : (showLoading
              ? Container(
                  color: Color(0XFFFFFFFF),
                  child: Center(
                    child:
                        loadingWidget ??
                        (PlaceHolderConfig.loadWidget ?? Container()),
                  ),
                )
              : (child ?? Container()));
    current = KeyedSubtree(key: ValueKey<int>(index), child: current);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: current,
    );
  }
}
