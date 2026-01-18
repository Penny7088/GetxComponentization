import 'dart:async';

import 'package:service_core/service_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_base/utils/light_model.dart';
import 'package:lib_base/utils/util.dart';
import 'package:flutter_bit_beat/app_binding.dart';
import 'package:flutter_bit_beat/env/env_config.dart';
import 'package:lib_uikit/i18n/lan_supported_local.dart';
import 'package:flutter_bit_beat/router/app_router.dart';
import 'package:lib_uikit/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:lib_uikit/i18n/i18n_tr_msg.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:feat_onboarding/onboarding_translations.dart';

void main() {
  runZonedGuarded(
    () => init(),
    (err, stace) {
      if (kDebugMode) {
        print(FlutterErrorDetails(exception: err, stack: stace));
      }
    },
    zoneSpecification: ZoneSpecification(
      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        parent.print(zone, line);
      },
    ),
  );
}

init() async {
  await configInit();
  runApp(initRunApp());
}

Widget initRunApp() {
  Widget body = initGetMaterialApp(
    builder: (context, child) {
      return initScreenUtil(
        builder: (p0, p1) {
          Widget body = initRootGestureDetector(child: child, context: context);
          return body;
        },
      );
    },
  );
  return body; // ...
}

Future<void> configInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
  await EnvConfig.initialize();
  await lightKV.config();
  AppBinding().dependencies();

  // 注册各模块翻译
  I18TRMessages.register(OnboardingTranslations.keys);
  // I18TRMessages.register(HomeTranslations.keys);
  // ...
}

Widget initScreenUtil({
  required Widget Function(BuildContext, Widget?) builder,
  bool useInheritedMediaQuery = true,
}) {
  return ScreenUtilInit(
    /// UI尺寸
    designSize: kIsWeb
        ? EnvConfig
              .instance
              .webDesignSize // 优先使用 Web 配置
        : EnvConfig.instance.designSize, // 移动端配置
    minTextAdapt: true,
    splitScreenMode: true,
    useInheritedMediaQuery: useInheritedMediaQuery,
    builder: builder,
  );
}

GestureDetector initRootGestureDetector({
  Widget? child,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: () {
      keyDismiss(context);
    },
    child: child,
  );
}

Widget initGetMaterialApp({Widget Function(BuildContext, Widget?)? builder}) {
  final themeController = Get.find<ThemeService>();
  final languageController = Get.find<LanguageService>();

  return GetMaterialApp(
    initialRoute: AppRouter.configNormalRouts(),
    getPages: AppRouter.getAllRoutS(),
    defaultTransition: Transition.rightToLeft,
    supportedLocales: LanguageSettingSupported.supportedLanguages,
    useInheritedMediaQuery: true,
    translations: I18TRMessages(),
    locale: languageController.locale.value,
    fallbackLocale: LanguageSettingSupported.fallbackLocale(),
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: themeController.themeMode.value,
    debugShowCheckedModeBanner: false,
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate, // ios
    ],
    builder: builder,
    onReady: () async {},
  );
}
