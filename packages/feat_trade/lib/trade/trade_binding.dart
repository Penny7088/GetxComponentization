import 'package:get/get.dart';
import 'package:feat_trade/trade/trade_controller.dart';

class TradeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TradeController());
  }
}
