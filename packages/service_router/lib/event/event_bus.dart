import 'dart:async';

/// 一个简单的事件总线，用于模块间通信
class EventBus {
  static EventBus? _instance;
  static EventBus get instance => _instance ??= EventBus._();

  EventBus._();

  final _streamController = StreamController.broadcast();

  /// 发送事件
  void fire(dynamic event) {
    _streamController.add(event);
  }

  /// 监听事件
  Stream<T> on<T>() {
    if (T == dynamic) {
      return _streamController.stream as Stream<T>;
    }
    return _streamController.stream.where((event) => event is T).cast<T>();
  }

  /// 关闭
  void destroy() {
    _streamController.close();
  }
}

/// 基础事件类（可选，建议业务事件继承此类）
abstract class AppEvent {}
