import 'package:feat_main/main_container/main_container_controller.dart';
import 'package:get/get.dart';
import 'package:feat_home/home/home_controller.dart';
import 'package:feat_trade/trade/trade_controller.dart';
import 'package:feat_market/market/market_controller.dart';
import 'package:feat_favorites/favorites/favorites_controller.dart';
import 'package:feat_wallet/wallet/wallet_controller.dart';

class MainContainerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainContainerController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => TradeController());
    Get.lazyPut(() => MarketController());
    Get.lazyPut(() => FavoritesController());
    Get.lazyPut(() => WalletController());
  }
}
