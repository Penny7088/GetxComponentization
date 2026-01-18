import 'package:flutter/material.dart';
import 'package:lib_base/getx/view/common_base_view.dart';
import 'package:feat_ui_sample/ui_sample/ui_controller.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lib_base/utils/toast_utils.dart';
import 'package:lib_uikit/widget/common_input_field.dart';
import 'package:lib_uikit/widget/common_verification_code.dart';
import 'package:lib_uikit/widget/common_button.dart';
import 'package:lib_uikit/widget/common_switch.dart';
import 'package:service_core/service_core.dart';
import 'package:service_router/service_router.dart';

class UiSamplePage extends CommonBaseView<UiSampleController> {
  const UiSamplePage({super.key});

  @override
  Widget createContentBody({
    required BuildContext context,
    BoxConstraints? constraints,
  }) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildThemeSection(context),
              const Divider(),
              _buildLanguageSection(),
              const Divider(),
              _buildInputSection(),
              const Divider(),
              _buildCommunicationDemoEntry(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommunicationDemoEntry() {
    return Column(
      children: [
        SizedBox(height: 20.h),
        AppText.heading('Module Communication Demo'),
        SizedBox(height: 10.h),
        CommonButton.primary(
          text: 'Open Communication Demo',
          onPressed: () => Get.toNamed(RouterPath.communicationDemo),
        ),
      ],
    );
  }

  Widget _buildInputSection() {
    return Column(
      children: [
        SizedBox(height: 20.h),
        AppText.heading('Input Field Demo'),
        SizedBox(height: 20.h),
        // Default
        const CommonInputField(
          labelText: 'Email address',
          hintText: 'Enter your email',
          prefixIcon: Icon(Icons.email_outlined),
        ),
        SizedBox(height: 16.h),
        // Filled
        CommonInputField(
          controller: TextEditingController(
            text: 'tomashuk.dima.1992@gmail.com',
          ),
          labelText: 'Email address',
          prefixIcon: const Icon(Icons.email_outlined),
        ),
        SizedBox(height: 16.h),
        // Success
        CommonInputField(
          controller: TextEditingController(
            text: 'tomashuk.dima.1992@gmail.com',
          ),
          labelText: 'Email address',
          prefixIcon: const Icon(Icons.email_outlined),
          inputStatus: InputStatus.success,
        ),
        SizedBox(height: 16.h),
        // Error
        CommonInputField(
          controller: TextEditingController(
            text: 'tomashuk.dima.1992gmail.com',
          ),
          labelText: 'Email address',
          prefixIcon: const Icon(Icons.email_outlined),
          inputStatus: InputStatus.error,
          errorText: 'Invalid email address',
          onSuffixTap: () {
            ToastUtils.toast('Error icon tapped! Clear action triggered.');
          },
        ),
        SizedBox(height: 16.h),
        // Live Validation
        Obx(
          () => CommonInputField(
            labelText: 'Live Validation Email',
            hintText: 'Type to validate...',
            prefixIcon: const Icon(Icons.mark_email_read_outlined),
            inputStatus: controller.emailStatus.value,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (val) => controller.validateEmail(val),
            validator: (val) {
              if (val == null || val.isEmpty) return null;
              if (!val.isEmail) return 'Please enter a valid email address';
              return null;
            },
          ),
        ),
        SizedBox(height: 16.h),
        // Password
        const CommonInputField(
          labelText: 'Password',
          hintText: 'Enter password',
          prefixIcon: Icon(Icons.lock_outline),
          isPassword: true,
        ),
        SizedBox(height: 20.h),
        AppText.heading('Verification Code'),
        SizedBox(height: 16.h),
        const CommonVerificationCode(length: 6),
        SizedBox(height: 16.h),
        // Error State Demo
        const CommonVerificationCode(length: 6, errorText: 'Invalid code'),
        SizedBox(height: 20.h),
        AppText.heading('Buttons Demo'),
        SizedBox(height: 16.h),
        CommonButton.primary(text: 'Primary Button', onPressed: () {}),
        SizedBox(height: 12.h),
        CommonButton.outline(text: 'Outline Button', onPressed: () {}),
        SizedBox(height: 12.h),
        CommonButton.destructive(text: 'Destructive Button', onPressed: () {}),
        SizedBox(height: 12.h),
        Obx(
          () => CommonButton.primary(
            text: 'Loading Button (Tap me)',
            isLoading: controller.isLoading.value,
            onPressed: () => controller.simulateLoading(),
          ),
        ),
        SizedBox(height: 12.h),
        CommonButton.primary(text: 'Disabled Button', onPressed: null),
        SizedBox(height: 12.h),
        CommonButton.primary(
          text: 'Button with Icon Left',
          icon: const Icon(Icons.arrow_back),
          iconPosition: ButtonIconPosition.left,
          onPressed: () {},
        ),
        SizedBox(height: 12.h),
        CommonButton.primary(
          text: 'Button with Icon Right',
          icon: const Icon(Icons.arrow_forward),
          iconPosition: ButtonIconPosition.right,
          onPressed: () {},
        ),
        SizedBox(height: 20.h),
        AppText.heading('Switch Demo'),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => CommonSwitch(
                value: controller.isSwitchOn.value,
                onChanged: (val) => controller.isSwitchOn.value = val,
              ),
            ),
            SizedBox(width: 20.w),
            // Disabled / Static
            CommonSwitch(value: true, onChanged: (val) {}),
          ],
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return Column(
      children: [
        AppText.heading('theme_switcher'.tr),
        SizedBox(height: 10.h),
        Obx(() {
          final mode = ThemeService.to.themeMode.value;
          return AppText.medium('Current Mode: $mode');
        }),
        SizedBox(height: 10.h),
        Container(
          width: 100.w,
          height: 50.h,
          color: Theme.of(context).primaryColor,
          alignment: Alignment.center,
          child: AppText.small('Primary Color', color: Colors.white),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.w,
          children: [
            ElevatedButton(
              onPressed: () => ThemeService.to.setTheme(ThemeMode.light),
              child: Text('light'.tr),
            ),
            ElevatedButton(
              onPressed: () => ThemeService.to.setTheme(ThemeMode.dark),
              child: Text('dark'.tr),
            ),
            ElevatedButton(
              onPressed: () => ThemeService.to.setTheme(ThemeMode.system),
              child: Text('system'.tr),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguageSection() {
    return Column(
      children: [
        SizedBox(height: 20.h),
        AppText.heading('Language Switcher'),
        SizedBox(height: 10.h),
        Obx(() {
          final locale = LanguageService.to.locale.value;
          return AppText.medium(
            'Current Locale: ${locale.languageCode}_${locale.countryCode}',
          );
        }),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.w,
          children: [
            ElevatedButton(
              onPressed: () =>
                  LanguageService.to.setLocale(const Locale('zh', 'CN')),
              child: const Text('中文'),
            ),
            ElevatedButton(
              onPressed: () =>
                  LanguageService.to.setLocale(const Locale('en', 'US')),
              child: const Text('English'),
            ),
          ],
        ),
      ],
    );
  }
}
