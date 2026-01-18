import 'package:feat_home/model/portfolio_chart_model.dart';
import 'package:get/get.dart';
import 'package:lib_base/getx/state/base_state.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:service_router/service_router.dart';

class HomeState extends BaseState {
  final IUserService _userService = Get.find<IUserService>();

  bool isLogin = false;
  String userName = '';
  bool hasUnreadMessages = false;

  // Portfolio Chart State
  PortfolioTimeRange selectedTimeRange = PortfolioTimeRange.day;
  late PortfolioChartData currentChartData;
  bool isChartExpanded = true;

  // Market Movers Data
  List<CryptoModel> marketMovers = [];
  // Single stream for all market movers updates
  late Stream<List<CryptoModel>> marketMoversStream;

  // Portfolio List Data (Reuse CryptoModel for simplicity)
  List<CryptoModel> portfolioList = [];
  late Stream<List<CryptoModel>> portfolioListStream;

  HomeState() {
    isShowLoading = true;
    isNeedScaffold = true;
    isShowAppBar = true;
    safeAreaTop = false; // 允许内容延伸到顶部状态栏
    safeAreaBottom = false; // 允许内容延伸到底部

    isLogin = _userService.isLogin;
    userName = _userService.userId;
  }
}
