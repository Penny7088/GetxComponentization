import 'package:service_router/service_router.dart';

/// 演示事件：模拟一个全局通知事件
class DemoNotificationEvent extends AppEvent {
  final String message;
  DemoNotificationEvent(this.message);
}
