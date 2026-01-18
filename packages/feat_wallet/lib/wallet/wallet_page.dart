import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_base/getx/view/common_base_view.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:feat_wallet/wallet/wallet_controller.dart';

class WalletPage extends CommonBaseView<WalletController> {
  const WalletPage({super.key});

  @override
  Widget createContentBody({
    required BuildContext context,
    BoxConstraints? constraints,
  }) {
    return Center(
      child: AppText.heading('Wallet Page'),
    );
  }
}
