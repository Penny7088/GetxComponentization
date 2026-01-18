import 'package:service_router/event/event_bus.dart';

/// 首页相关事件
class HomePageMessageEvent extends AppEvent {
  final String message;
  final String from;
  
  HomePageMessageEvent({required this.message, required this.from});
}
