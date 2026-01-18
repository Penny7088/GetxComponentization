import 'package:feat_onboarding/onboarding/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:lib_base/getx/view/common_base_view.dart';
import 'package:lib_uikit/utils/image_utils.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:lib_uikit/widget/common_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'onboarding_state.dart';

class OnboardingPage extends CommonBaseView<OnboardingController> {
  const OnboardingPage({super.key});

  @override
  Widget createContentBody({
    required BuildContext context,
    BoxConstraints? constraints,
  }) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          20.verticalSpace,
          _buildHeader(),
          // Body: PageView
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: controller.state.items.length,
              onPageChanged: controller.onPageChanged,
              itemBuilder: (context, index) {
                final item = controller.state.items[index];
                return _buildPageItem(item);
              },
            ),
          ),
          // Footer: Text, Dots, Button
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 模拟 Logo 图标
          Icon(
            Icons.hexagon_outlined,
            color: const Color(0xFF246BFD),
            size: 24.w,
          ),
          8.horizontalSpace,
          AppText.heading(
            'Bit Beat',
            fontSize: 20.sp,
            color: const Color(0xFF246BFD),
          ),
        ],
      ),
    );
  }

  Widget _buildPageItem(OnboardingItem item) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 波浪背景 (仅在图片区域底部)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ImageUtils.getOnboardingImage(
            'onboardig_wave.webp',
            package: 'feat_onboarding',
            fit: BoxFit.fill,
            height: 200.h,
          ),
        ),
        // 主图
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: ImageUtils.getOnboardingImage(
            item.image,
            fit: BoxFit.contain,
            package: 'feat_onboarding',
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            final item = controller.state.items[controller.currentPage.value];
            return Column(
              children: [
                AppText.heading(
                  item.title,
                  textAlign: TextAlign.center,
                  fontSize: 24,
                  color: Colors.black,
                ),
                SizedBox(height: 12.h),
                AppText.small(
                  item.description,
                  textAlign: TextAlign.center,
                  color: Colors.grey,
                  maxLines: 3,
                ),
              ],
            );
          }),
          SizedBox(height: 30.h),
          // Dots Indicator
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.state.items.length,
                (index) => _buildDot(index),
              ),
            ),
          ),
          SizedBox(height: 30.h),
          // Next Button
          CommonButton.primary(
            text: 'Next',
            backgroundColor: const Color(0xFF246BFD),
            height: 48.h,
            borderRadius: 12.r,
            onPressed: controller.next,
          ),
          SizedBox(height: 20.h), // 底部安全距离
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    final isActive = controller.currentPage.value == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      height: 6.h,
      width: isActive ? 24.w : 6.w,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF246BFD) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(3.r),
      ),
    );
  }
}
