import 'package:feat_main/main_container/main_container_controller.dart';
import 'package:flutter/material.dart';
import 'package:lib_base/getx/view/common_base_view.dart';
import 'package:lib_uikit/utils/image_utils.dart';
import 'package:lib_uikit/widget/common_bottom_bar.dart';
import 'package:get/get.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:feat_home/home/home_page.dart';
import 'package:feat_trade/trade/trade_page.dart';
import 'package:feat_market/market/market_page.dart';
import 'package:feat_favorites/favorites/favorites_page.dart';
import 'package:feat_wallet/wallet/wallet_page.dart';

class MainContainerPage extends CommonBaseView<MainContainerController> {
  const MainContainerPage({super.key});

  @override
  Widget createContentBody({
    required BuildContext context,
    BoxConstraints? constraints,
  }) {
    return Obx(
      () => IndexedStack(
        index: controller.currentIndex.value,
        children: [
          HomePage(),
          TradePage(),
          MarketPage(),
          FavoritesPage(),
          WalletPage(),
        ],
      ),
    );
  }

  @override
  Widget? createScaffoldBottomNavigationBar({
    required BuildContext context,
    BoxConstraints? constraints,
  }) {
    return Obx(
      () => CommonBottomBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changeTab,
        items: [
          BottomBarItem(
            label: 'home'.tr,
            icon: ImageUtils.getThemeSvg(
              context,
              'bottom_home_disable',
              package: 'feat_main',
            ),
            activeIcon: ImageUtils.getThemeSvg(
              context,
              'bottom_home',
              package: 'feat_main',
            ),
          ),
          BottomBarItem(
            label: 'trade'.tr,
            icon: ImageUtils.getThemeSvg(
              context,
              'bottom_trade_disable',
              package: 'feat_main',
            ),
            activeIcon: ImageUtils.getThemeSvg(
              context,
              'bottom_trade',
              package: 'feat_main',
            ),
          ),
          BottomBarItem(
            label: 'market'.tr,
            icon: ImageUtils.getThemeSvg(
              context,
              'bottom_market_disable',
              package: 'feat_main',
            ),
            activeIcon: ImageUtils.getThemeSvg(
              context,
              'bottom_market',
              package: 'feat_main',
            ),
          ),
          BottomBarItem(
            label: 'favorites'.tr,
            icon: ImageUtils.getThemeSvg(
              context,
              'bottom_favorites_disable',
              package: 'feat_main',
            ),
            activeIcon: ImageUtils.getThemeSvg(
              context,
              'bottom_favorites',
              package: 'feat_main',
            ),
          ),
          BottomBarItem(
            label: 'wallet'.tr,
            icon: ImageUtils.getThemeSvg(
              context,
              'bottom_wallet_disable',
              package: 'feat_main',
            ),
            activeIcon: ImageUtils.getThemeSvg(
              context,
              'bottom_wallet',
              package: 'feat_main',
            ),
          ),
        ],
      ),
    );
  }
}
