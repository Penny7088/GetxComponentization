import 'package:feat_home/widget/portfolio_list_section.dart';
import 'package:feat_home/widget/market_movers_section.dart';
import 'package:feat_home/widget/portfolio_overview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_base/getx/view/common_base_list_view.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:lib_uikit/widget/common_button.dart';
import 'package:lib_uikit/widget/common_first_text_avatar.dart';
import 'package:lib_uikit/utils/image_utils.dart';
import 'package:feat_home/home/home_controller.dart';

class HomePage extends CommonBaseListView<HomeController> {
  const HomePage({super.key});

  @override
  bool get enableLoadMore => false;

  @override
  Widget? createLoadingWidget() {
    return Center(child: CircularProgressIndicator());
  }

  @override
  List<Widget>? createAppBarActions() {
    return [
      IconButton(
        onPressed: () {},
        icon: ImageUtils.getThemeSvg(
          Get.context!,
          'customer_icon',
          package: 'feat_home',
          width: 24,
          height: 24,
        ),
      ),
      const SizedBox(width: 8),
      GetBuilder<HomeController>(
        id: 'msg_badge',
        builder: (_) {
          return Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: ImageUtils.getThemeSvg(
                  Get.context!,
                  controller.state.hasUnreadMessages
                      ? 'msg_icon_unread'
                      : 'msg_icon',
                  package: 'feat_home',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          );
        },
      ),
    ];
  }

  @override
  Widget? createAppBarTitleWidget() {
    return AppText.heading('Bit Beat', fontSize: 28);
  }

  @override
  Widget? createAppBarLeading() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: GetBuilder<HomeController>(
          id: ['user_status'],
          builder: (_) {
            final state = controller.state;
            if (state.isLogin) {
              return CommonFirstTextAvatar(text: state.userName, size: 24);
            } else {
              return ImageUtils.getThemeSvg(
                Get.context!,
                'profile_setting_icon',
                package: 'feat_home',
                width: 24,
                height: 24,
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget createListView(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: GetBuilder<HomeController>(
            id: 'user_status',
            builder: (_) {
              return PortfolioOverview(
                isLogin: controller.state.isLogin,
                onLoginTap: controller.goToLogin,
                selectedTimeRange: controller.state.selectedTimeRange,
                chartData: controller.state.currentChartData,
                onTimeRangeChanged: controller.switchTimeRange,
                isExpanded: controller.state.isChartExpanded,
                onToggleExpansion: controller.toggleChartExpansion,
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: GetBuilder<HomeController>(
            id: 'market_movers',
            builder: (_) {
              return MarketMoversSection(
                data: controller.state.marketMovers,
                stream: controller.state.marketMoversStream,
                onMoreTap: () {
                  // Handle more tap
                },
                onCardTap: (item) {
                  // Handle card tap
                },
              );
            },
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GetBuilder<HomeController>(
                  id: ['portfolio_list'],
                  builder: (_) {
                    return PortfolioListSection(
                      data: controller.state.portfolioList,
                      stream: controller.state.portfolioListStream,
                      onMoreTap: () {
                        // Handle more tap
                      },
                      onItemTap: (item) {
                        // Handle item tap
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 20),
                Obx(() {
                  if (controller.messages.isEmpty) {
                    return AppText.small('No messages received yet');
                  }
                  return Column(
                    children: [
                      AppText.medium('Received Messages:'),
                      const SizedBox(height: 10),
                      ...controller.messages.map(
                        (msg) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: AppText.small(msg),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 30),
                CommonButton.primary(
                  text: 'Go to UI Sample',
                  onPressed: controller.goToUiSample,
                  width: 200,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
