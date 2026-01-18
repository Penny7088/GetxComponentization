
import 'package:dio/dio.dart';

/// dio 配置项
class HttpConfig {
  final String? baseUrl;
  final List<Interceptor>? interceptors;
  final Duration? connectTimeout;
  final Duration? sendTimeout;
  final Duration? receiveTimeout;
  final bool? isNeedLog;
  final Map<String, dynamic>? headers;
  HttpClientAdapter? httpClientAdapter;

  /// 网络缓存 状态值
  final int cacheStatusCode;

  HttpConfig._internal(
      {this.baseUrl,
      this.headers,
      this.interceptors,
      this.isNeedLog = true,
      this.cacheStatusCode = 304,
      this.connectTimeout,
      this.sendTimeout,
      this.receiveTimeout,
      this.httpClientAdapter});

  HttpConfig.build(HttpConfigBuilder build)
      : this._internal(
            baseUrl: build.baseUrl,
            httpClientAdapter: build.httpClientAdapter,
            interceptors: build.interceptors,
            connectTimeout: build.connectTimeout,
            sendTimeout: build.sendTimeout,
            receiveTimeout: build.receiveTimeout,
            headers: build.headers,
            isNeedLog: build.isPrintLog);
}

class HttpConfigBuilder {
  String? _baseUrl;
  HttpClientAdapter? _httpClientAdapter;
  List<Interceptor>? _interceptors;
  Duration? _connectTimeout;
  Duration? _sendTimeout;
  Duration? _receiveTimeout;
  Map<String, dynamic>? _headers;
  bool? _isNeedLog;

  HttpConfigBuilder setBaseUrl(String baseUrl) {
    _baseUrl = baseUrl;
    return this;
  }

  HttpConfigBuilder setConnectTimeout(Duration connectTimeout) {
    _connectTimeout = connectTimeout;
    return this;
  }

  HttpConfigBuilder setHttpClientAdapter(HttpClientAdapter httpClientAdapter) {
    _httpClientAdapter = httpClientAdapter;
    return this;
  }

  HttpConfigBuilder addHeaders(Map<String, dynamic> headers) {
    _headers = headers;
    return this;
  }

  HttpConfigBuilder addInterceptor(Interceptor interceptors) {
    _interceptors ??= [];
    _interceptors!.add(interceptors);
    return this;
  }

  HttpConfigBuilder addAllInterceptors(List<Interceptor> interceptors) {
    _interceptors ??= [];
    _interceptors!.addAll(interceptors);
    return this;
  }

  HttpConfigBuilder setReceiveTimeout(Duration receiveTimeout) {
    _receiveTimeout = receiveTimeout;
    return this;
  }

  HttpConfigBuilder setSendTimeout(Duration sendTimeout) {
    _sendTimeout = sendTimeout;
    return this;
  }

  HttpConfigBuilder isNeedLog(bool isNeedLog) {
    _isNeedLog = isNeedLog;
    return this;
  }

  HttpConfig create() {
    return HttpConfig.build(this);
  }

  String? get baseUrl => _baseUrl;

  bool? get isPrintLog => _isNeedLog;

  HttpClientAdapter? get httpClientAdapter => _httpClientAdapter;

  List<Interceptor>? get interceptors => _interceptors;

  Duration? get connectTimeout => _connectTimeout;

  Duration? get sendTimeout => _sendTimeout;

  Duration? get receiveTimeout => _receiveTimeout;

  Map<String, dynamic>? get headers => _headers;

}
