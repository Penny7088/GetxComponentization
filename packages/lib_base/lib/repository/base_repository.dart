import 'package:dio/dio.dart';
import 'package:lib_base/http/client.dart';
import 'package:lib_base/http/http_response.dart';

/// 所有 Repository 的基类
/// 负责持有 HttpClient 实例，并提供通用的请求处理逻辑
abstract class BaseRepository {
  late final HttpClient _client;
  
  // 可以在这里持有 CancelToken，方便在页面销毁时取消请求
  final CancelToken _cancelToken = CancelToken();

  BaseRepository() {
    _client = HttpClient.singleton();
  }

  HttpClient get client => _client;
  CancelToken get cancelToken => _cancelToken;

  /// 销毁 Repository 时调用，取消所有未完成的请求
  void dispose() {
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel('Repository disposed');
    }
  }

  /// 辅助方法：处理通用响应逻辑（如果有需要）
  /// 例如：统一处理 401，或者解包 data
  Future<T?> request<T>(Future<ApiResponse> Function() requestCall) async {
    final response = await requestCall();
    if (response.ok) {
      return response.data as T?;
    } else {
      // 这里可以抛出异常，或者由上层处理错误
      // throw response.error ?? Exception(response.msg);
      return null;
    }
  }
}
