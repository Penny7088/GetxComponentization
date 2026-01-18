import 'package:lib_base/getx/state/base_state.dart';

class MarketState extends BaseState {
  MarketState() {
    isNeedScaffold = true;
    isShowAppBar = false; // 显示 AppBar
    safeAreaTop = true; // 允许内容延伸到顶部状态栏
    safeAreaBottom = false; // 允许内容延伸到底部
  }
}
