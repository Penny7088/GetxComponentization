import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lib_base/getx/view/common_base_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'splash_controller.dart';

class SplashPage extends CommonBaseView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget createContentBody({
    required BuildContext context,
    BoxConstraints? constraints,
  }) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      color: Theme.of(context).scaffoldBackgroundColor, // 使用主题背景色
      // 交易所名字动画
      child: Hero(
        tag: 'splash_logo_text',
        child: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              'Bit Beat',
              textStyle: TextStyle(
                fontSize: 40.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontFamily: 'Readex Pro',
              ),
              speed: const Duration(milliseconds: 200),
              cursor: '',
            ),
          ],
          totalRepeatCount: 1,
          pause: const Duration(milliseconds: 1000),
          displayFullTextOnTap: true,
          stopPauseOnTap: true,
          onFinished: () {
            // 动画结束后跳转，逻辑在 Controller 中处理
            controller.onAnimationFinished();
          },
        ),
      ),
    );
  }
}
