import 'package:get/get.dart';
import 'package:flutter_bit_beat/env/env_config.dart';
import 'package:service_core/service_core.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // 核心业务服务 (Auth, Config, Socket, Theme, Language)
    CoreBinding().dependencies();

    // 初始化 WebSocket 服务 (需要在 CoreBinding 注册后进行 init)
    // 注意：Get.putAsync 在 CoreBinding 中已经注册了 SocketService，
    // 但我们需要在这里调用 init 来传入环境配置，或者修改 CoreBinding 让其能读取配置
    // 这里采用查找并初始化的方式：
    Future.delayed(Duration.zero, () async {
      final socketService = Get.find<SocketService>();
      await socketService.init(
        baseUrl: EnvConfig.instance.wsBaseUrl,
        token: '', // 从 AuthService 获取
      );
      // socketService.connect();
    });
  }
}
