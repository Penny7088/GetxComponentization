import 'dart:async';
import 'dart:math';
import 'package:feat_home/home/home_state.dart';
import 'package:feat_home/model/portfolio_chart_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lib_base/getx/controller/common_list_controller.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:service_router/service_router.dart';

class HomeController extends CommonListController<HomeState> {
  final RxList<String> messages = <String>[].obs;
  Timer? _timer;
  final Random _random = Random();
  // Single StreamController for all market movers
  final StreamController<List<CryptoModel>> _marketMoversController =
      StreamController<List<CryptoModel>>.broadcast();
  // StreamController for portfolio list
  final StreamController<List<CryptoModel>> _portfolioListController =
      StreamController<List<CryptoModel>>.broadcast();

  @override
  HomeState createState() {
    return HomeState();
  }

  @override
  void onInit() {
    super.onInit();
    // Listen for messages from CommunicationDemo
    EventBus.instance.on<HomePageMessageEvent>().listen((event) {
      messages.add('[${event.from}]: ${event.message}');
      // 更新未读消息状态
      state.hasUnreadMessages = true;
      update(['msg_badge']);
    });
  }

  @override
  Future<void> configWidgetRenderingCompleted() async {
    Future.delayed(Duration(seconds: 2), () {
      state.isShowLoading = false;
      switchTimeRange(PortfolioTimeRange.day);
      _initMarketMovers();
      _initPortfolioList();
      _startDataSimulation();
      setData();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    _marketMoversController.close();
    _portfolioListController.close();
    super.onClose();
  }

  void _startDataSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _updateMarketMovers();
      _updatePortfolioList();
    });
  }

  void _updateMarketMovers() {
    final updatedMovers = state.marketMovers.map((mover) {
      // Simulate price change (-0.5% to +0.5%)
      final changeFactor = 1 + (_random.nextDouble() * 0.01 - 0.005);
      final newPrice = mover.currentPrice * changeFactor;

      // Update chart data: remove first, add new price
      final newChartData = List<double>.from(mover.chartData);
      if (newChartData.isNotEmpty) {
        newChartData.removeAt(0);
        newChartData.add(newPrice);
      }

      // Calculate new change percent
      final newChangePercent =
          mover.changePercent + (_random.nextDouble() * 0.2 - 0.1);

      final updatedModel = CryptoModel(
        symbol: mover.symbol,
        pair: mover.pair,
        currentPrice: newPrice,
        changePercent: newChangePercent,
        volume: mover.volume,
        chartData: newChartData,
        name: mover.name,
        topPrice: mover.topPrice,
        lowPrice: mover.lowPrice,
      );

      // Add to stream
      // _streamControllers[mover.symbol]?.add(updatedModel);

      return updatedModel;
    }).toList();

    // Only update state reference, but don't call update() to avoid full rebuilds
    state.marketMovers = updatedMovers;
    // Broadcast the full list update
    _marketMoversController.add(updatedMovers);
  }

  void _initMarketMovers() {
    final initialMovers = [
      CryptoModel(
        symbol: 'BTC',
        pair: 'USD',
        currentPrice: 30113.80,
        changePercent: 2.76,
        volume: '394 897 432,26',
        chartData: [30000, 30100, 30050, 30200, 30150, 30300, 30113.80],
        name: 'Bitcoin',
        topPrice: '30300',
        lowPrice: '30000',
      ),
      CryptoModel(
        symbol: 'SOL',
        pair: 'USD',
        currentPrice: 40.11,
        changePercent: 3.75,
        volume: '150 897 992,26',
        chartData: [38, 39, 38.5, 40, 39.5, 41, 40.11],
        name: 'Solana',
        topPrice: '41',
        lowPrice: '38',
      ),
      CryptoModel(
        symbol: 'ETH',
        pair: 'USD',
        currentPrice: 1850.50,
        changePercent: -1.20,
        volume: '210 555 123,00',
        chartData: [1900, 1880, 1890, 1860, 1870, 1840, 1850.50],
        name: 'Ethereum',
        topPrice: '1900',
        lowPrice: '1840',
      ),
    ];

    state.marketMovers = initialMovers;

    // Initialize stream
    _marketMoversController.add(initialMovers);
    state.marketMoversStream = _marketMoversController.stream;

    update(['market_movers']);
  }

  void switchTimeRange(PortfolioTimeRange range) {
    state.selectedTimeRange = range;
    state.currentChartData = _getMockDataForRange(range);
    update(['user_status']);
  }

  void toggleChartExpansion() {
    state.isChartExpanded = !state.isChartExpanded;
    update(['user_status']);
  }

  PortfolioChartData _getMockDataForRange(PortfolioTimeRange range) {
    switch (range) {
      case PortfolioTimeRange.day:
        return const PortfolioChartData(
          maxX: 4,
          maxY: 6,
          verticalDivisions: 4,
          bottomLabels: ['10:00', '12:00', '14:00', '16:00', '18:00'],
          spots: [
            FlSpot(0, 2),
            FlSpot(1, 1.5),
            FlSpot(1.8, 5),
            FlSpot(2.6, 2.5),
            FlSpot(3.3, 4.5),
            FlSpot(3.6, 3.5),
            FlSpot(4, 5),
          ],
        );
      case PortfolioTimeRange.week:
        return const PortfolioChartData(
          maxX: 6,
          maxY: 8,
          verticalDivisions: 6,
          bottomLabels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
          spots: [
            FlSpot(0, 3),
            FlSpot(1, 4),
            FlSpot(2, 3.5),
            FlSpot(3, 5),
            FlSpot(4, 4.5),
            FlSpot(5, 6),
            FlSpot(6, 5.5),
          ],
        );
      case PortfolioTimeRange.month:
        return const PortfolioChartData(
          maxX: 5,
          maxY: 10,
          verticalDivisions: 5,
          bottomLabels: ['1', '7', '14', '21', '28', '30'],
          spots: [
            FlSpot(0, 4),
            FlSpot(1, 6),
            FlSpot(2, 5),
            FlSpot(3, 8),
            FlSpot(4, 7),
            FlSpot(5, 9),
          ],
        );
      case PortfolioTimeRange.sixMonth:
        return const PortfolioChartData(
          maxX: 5,
          maxY: 12,
          verticalDivisions: 5,
          bottomLabels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
          spots: [
            FlSpot(0, 5),
            FlSpot(1, 7),
            FlSpot(2, 6),
            FlSpot(3, 9),
            FlSpot(4, 8),
            FlSpot(5, 10),
          ],
        );
    }
  }

  void _initPortfolioList() {
    final initialPortfolio = [
      CryptoModel(
        symbol: 'BTC',
        pair: 'USD',
        currentPrice: 30113.80,
        changePercent: 2.76,
        volume: '394 897 432,26',
        chartData: [],
        name: 'Bitcoin',
        topPrice: '30300',
        lowPrice: '30000',
      ),
      CryptoModel(
        symbol: 'ETH',
        pair: 'USD',
        currentPrice: 1850.50,
        changePercent: -1.20,
        volume: '210 555 123,00',
        chartData: [],
        name: 'Ethereum',
        topPrice: '1900',
        lowPrice: '1840',
      ),
      CryptoModel(
        symbol: 'XRP',
        pair: 'USD',
        currentPrice: 0.52,
        changePercent: 0.85,
        volume: '55 123 000,00',
        chartData: [],
        name: 'Ripple',
        topPrice: '0.60',
        lowPrice: '0.45',
      ),
    ];

    state.portfolioList = initialPortfolio;
    _portfolioListController.add(initialPortfolio);
    state.portfolioListStream = _portfolioListController.stream;

    update(['portfolio_list']);
  }

  void _updatePortfolioList() {
    final updatedList = state.portfolioList.map((item) {
      // Simulate price change
      final changeFactor = 1 + (_random.nextDouble() * 0.01 - 0.005);
      final newPrice = item.currentPrice * changeFactor;
      final newChangePercent =
          item.changePercent + (_random.nextDouble() * 0.2 - 0.1);

      return CryptoModel(
        symbol: item.symbol,
        pair: item.pair,
        currentPrice: newPrice,
        changePercent: newChangePercent,
        volume: item.volume,
        chartData: item.chartData,
        name: item.name,
        topPrice: item.topPrice,
        lowPrice: item.lowPrice,
      );
    }).toList();

    state.portfolioList = updatedList;
    _portfolioListController.add(updatedList);
  }

  void goToLogin() {
    // 暂时模拟跳转登录，实际应跳转到 Login 页面
    // Get.toNamed(RouterPath.login);
    // 这里为了演示，直接触发一个登录事件或 Toast
    // 假设调用 AuthService 的 login (这里仅仅是演示，实际应该是 UI 操作)
    // 正常流程：Get.toNamed(RouterPath.login);
    debugPrint('Navigate to Login Page');
    state.isLogin = true;
    update(['user_status']);
  }

  void goToUiSample() {
    Get.toNamed(RouterPath.uiSample);
  }
}
