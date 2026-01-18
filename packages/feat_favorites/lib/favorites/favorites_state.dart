import 'package:lib_base/getx/state/base_state.dart';

class FavoritesState extends BaseState {
  FavoritesState() {
    isNeedScaffold = true;
    isShowAppBar = true; // 显示AppBar
    safeAreaTop = false; // 允许内容延伸到顶部状态栏
    safeAreaBottom = false; // 允许内容延伸到底部
  }
}
