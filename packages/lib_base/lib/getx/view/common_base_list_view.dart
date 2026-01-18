import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/widgets.dart';

import '../../utils/common_refresh_widgets.dart';
import '../state/base_state.dart';
import '../controller/common_list_controller.dart';
import 'common_base_view.dart';
import 'mixin/refresh_mixin.dart';

/// FileName common_base_list_view
///
/// @Author mac
/// @Date 2024/5/28 17:48
///
/// @Description TODO

abstract class CommonBaseListView<C extends CommonListController<BaseState>>
    extends CommonBaseView<C> with AbstractRefreshWidget {
  const CommonBaseListView({super.key});

  @override
  Widget createContentBody(
      {required BuildContext context, BoxConstraints? constraints}) {
    return createRefreshWidget(context);
  }

  bool get enableLoadMore => true;

  @override
  Widget createRefreshWidget(BuildContext context) {
    Widget body = EasyRefresh(
      key: key,
      controller: controller.refreshController,
      onRefresh: () async {
        controller.configRefresh();
      },
      onLoad: enableLoadMore
          ? () async {
              controller.configLoading();
            }
          : null,
      header: createHeader(),
      footer: createFooter(),
      scrollController: setScrollController(),
      child: createListView(context),
    );
    return body;
  }

  setScrollController() {
    return null;
  }

  Header? createHeader() {
    return CommonRefreshWidget.configHeader();
  }

  Footer? createFooter() {
    return CommonRefreshWidget.configFooter();
  }
}
