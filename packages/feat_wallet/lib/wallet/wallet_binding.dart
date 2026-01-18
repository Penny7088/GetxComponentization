import 'package:get/get.dart';
import 'package:feat_wallet/wallet/wallet_controller.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WalletController());
  }
}
