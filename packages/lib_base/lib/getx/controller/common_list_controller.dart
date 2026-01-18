import 'package:easy_refresh/easy_refresh.dart';

import '../../enum/page_state.dart';
import '../state/base_state.dart';
import '../view/mixin/refresh_mixin.dart';
import 'common_controller.dart';

/// FileName common_list_controller
///
/// @Author mac
/// @Date 2024/5/28 17:33
///
/// @Description  list controller

abstract class CommonListController<S extends BaseState>
    extends CommonController<S> with AbstractRefreshMethod {
  EasyRefreshController? refreshController;
  bool controlFinishRefresh = true;
  bool controlFinishLoad = true;

  // 可自定义分页参数
  int get initPage => 1;
  String get pageKey => 'page';
  String get pageSizeKey => 'pageSize';

  @override
  void onInit() {
    page = initPage;
    super.onInit();
    configRefreshController();
  }

  @override
  void configRefreshController() {
    refreshController = EasyRefreshController(
      controlFinishLoad: controlFinishLoad,
      controlFinishRefresh: controlFinishRefresh,
    );
  }

  // 上拉加载
  @override
  void configLoading() {
    page++;
    fetchNetWorkData(
      refreshType: RefreshType.push,
    );
  }

  // 下啦刷新
  @override
  void configRefresh() {
    page = initPage;
    fetchNetWorkData(
      refreshType: RefreshType.pull,
    );
  }

  // 配置结束刷新操作
  PageState configRefreshPageState({
    int? allNum,
    int? netWorkNum,
    required RefreshType type,
  }) {
    final st = endRefresh(
      type: type,
      state: configPageState(
        allNum: allNum ?? 0,
        networkNum: netWorkNum ?? 0,
      ),
    );
    if (st == PageState.dataFetchState) {
      setData();
    } else if (st == PageState.emptyDataState) {
      setEmpty();
    } else if (st == PageState.noMoreDataState) {
      setNoMore();
    } else if (st == PageState.errorState ||
        st == PageState.errorOnlyTotal ||
        st == PageState.errorShowRefresh) {
      setError(showRefresh: st == PageState.errorShowRefresh);
    } else {
      setPageState(st);
    }
    return st;
  }

  @override
  PageState endRefresh({required RefreshType type, required PageState state}) {
    return configEndRefresh(
      type: type,
      state: state,
      refreshController: refreshController,
    );
  }

  @override
  void onClose() {
    try {
      refreshController?.dispose();
    } finally {
      refreshController = null;
      super.onClose();
    }
  }
}
