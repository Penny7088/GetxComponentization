import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lib_base/enum/common_place_hold_type.dart';

import '../../enum/page_state.dart';
import '../../utils/getx_util_tool.dart';
import '../state/base_state.dart';
import '../view/mixin/refresh_mixin.dart';

abstract class CommonController<S extends BaseState> extends GetxController
    with AbstractNetWork {
  CommonPlaceHoldType placeHoldType = CommonPlaceHoldType.nothing;

  /// 缺省页 描述语
  String? placeMsg;

  /// 缺省页 按钮文字
  String? placeBtnMsg;

  late S _state = createState();

  S get state => _state;

  set state(S value) {
    _state = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      configWidgetRenderingCompleted();
    });
  }

  S createState();

  /// 界面渲染完成
  Future<void> configWidgetRenderingCompleted() async {}

  // 点击缺省页触发事件
  void tapPlaceHoldWidgetMethod({required CommonPlaceHoldType placeHoldType}) {}

  /// 点击返回按钮触发事件
  void tapNormalBack() {
    currentGoBack();
  }

  @override
  void onClose() {
    super.onClose();
    state.release();
  }

  /// 状态切换工具
  void setInitialized({bool showLoading = true, String? msg}) {
    state.pageState = PageState.initializedState;
    state.isShowLoading = showLoading;
    if (msg != null) {
      state.msg = msg;
    }
  }

  void setData({String? msg}) {
    state.pageState = PageState.dataFetchState;
    state.isShowLoading = false;
    update();
  }

  void setEmpty({String? msg}) {
    state.pageState = PageState.emptyDataState;
    state.isShowLoading = false;
    if (msg != null) {
      state.msg = msg;
      update();
    }
  }

  void setNoMore({String? msg}) {
    state.pageState = PageState.noMoreDataState;
    state.isShowLoading = false;
    if (msg != null) {
      state.msg = msg;
      update();
    }
  }

  void setError({
    String? msg,
    bool toastOnly = false,
    bool showRefresh = false,
  }) {
    final ps = toastOnly
        ? PageState.errorOnlyTotal
        : (showRefresh ? PageState.errorShowRefresh : PageState.errorState);
    state.pageState = ps;
    state.isShowLoading = false;
    if (msg != null) {
      state.msg = msg;
      update();
    }
  }

  void setPageState(PageState ps, {bool? showLoading, String? msg}) {
    state.pageState = ps;
    if (showLoading != null) {
      state.isShowLoading = showLoading;
    }
    if (msg != null) {
      state.msg = msg;
      update();
    }
  }

  void markNeedsBuild([List<Object>? ids]) {
    update(ids);
  }

  void patchState(void Function(S s) fn, {List<Object>? ids}) {
    fn(state);
    update(ids);
  }
}
