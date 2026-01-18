import 'package:get/get.dart';
import 'package:feat_market/market/market_controller.dart';

class MarketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MarketController());
  }
}
