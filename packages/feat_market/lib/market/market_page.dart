import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_base/getx/view/common_base_view.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:feat_market/market/market_controller.dart';

class MarketPage extends CommonBaseView<MarketController> {
  const MarketPage({super.key});

  @override
  Widget createContentBody({
    required BuildContext context,
    BoxConstraints? constraints,
  }) {
    return Center(
      child: AppText.heading('Market Page'),
    );
  }
}
