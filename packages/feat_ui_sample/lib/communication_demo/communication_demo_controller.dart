import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_base/getx/controller/common_controller.dart';
import 'package:lib_base/getx/state/base_state.dart';
import 'package:service_core/service_core.dart';
import 'package:service_router/service_router.dart';
import 'demo_event.dart';

class CommunicationDemoState extends BaseState {
  CommunicationDemoState() {
    appBarTitle = '模块通信演示';
  }
}

class CommunicationDemoController
    extends CommonController<CommunicationDemoState> {
  // 1. Service 调用演示
  final authService = Get.find<IUserService>();
  final themeService = ThemeService.to;

  final RxString userStatus = ''.obs;
  final RxString eventLog = ''.obs;

  @override
  CommunicationDemoState createState() => CommunicationDemoState();

  @override
  void onInit() {
    super.onInit();
    _updateUserStatus();

    // 2. EventBus 监听演示
    // 监听来自其他地方（或者自己发出的）DemoNotificationEvent
    EventBus.instance.on<DemoNotificationEvent>().listen((event) {
      eventLog.value =
          '${DateTime.now().toString().split(' ')[1]}: 收到事件 -> ${event.message}\n${eventLog.value}';
    });
  }

  void _updateUserStatus() {
    userStatus.value = authService.isLogin
        ? '已登录 (User: ${authService.userId})'
        : '未登录';
  }

  // 模拟登录/登出
  Future<void> toggleLogin() async {
    if (authService.isLogin) {
      await authService.logout();
    } else {
      await authService.login('demo_user', 'password');
    }
    _updateUserStatus();
  }

  // 切换主题
  void toggleTheme() {
    if (themeService.isDarkMode) {
      themeService.setTheme(ThemeMode.light);
    } else {
      themeService.setTheme(ThemeMode.dark);
    }
  }

  // 发送事件
  void sendEvent() {
    EventBus.instance.fire(
      DemoNotificationEvent('Hello from Communication Demo!'),
    );

    // Send message to HomePage
    EventBus.instance.fire(
      HomePageMessageEvent(
        message:
            'Hello Home! Message sent at ${DateTime.now().toString().split(' ')[1]}',
        from: 'Communication Demo',
      ),
    );
  }

  // 路由跳转
  void goToHome() {
    Get.toNamed(RouterPath.main);
  }
}
