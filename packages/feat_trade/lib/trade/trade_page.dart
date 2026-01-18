import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_base/getx/view/common_base_view.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:feat_trade/trade/trade_controller.dart';

class TradePage extends CommonBaseView<TradeController> {
  const TradePage({super.key});

  @override
  Widget createContentBody({
    required BuildContext context,
    BoxConstraints? constraints,
  }) {
    return Center(
      child: AppText.heading('Trade Page'),
    );
  }
}
