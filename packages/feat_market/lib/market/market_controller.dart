import 'package:feat_market/market/market_state.dart';
import 'package:get/get.dart';
import 'package:lib_base/getx/controller/common_controller.dart';

class MarketController extends CommonController<MarketState> {
  @override
  MarketState createState() {
    return MarketState();
  }
}
