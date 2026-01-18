import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'transformer.dart';
import 'http_config.dart';
import 'http_parse.dart';
import 'http_response.dart';

class HttpClient {
  static const defaultClientTag = "network";
  static HttpClient? _singleton;
  final HttpConfig? _normalHttpConfig;
  late final Dio _normalDio;
  Dio get dio => _normalDio;
  HttpClient({BaseOptions? options, HttpConfig? normalHttpConfig})
    : _normalHttpConfig = normalHttpConfig,
      _normalDio = _createDio(
        options: options,
        normalHttpConfig: normalHttpConfig,
      );

  static Dio _createDio({BaseOptions? options, HttpConfig? normalHttpConfig}) {
    options ??= BaseOptions(
      baseUrl: normalHttpConfig?.baseUrl ?? "",
      contentType: 'application/json',
      sendTimeout: normalHttpConfig?.sendTimeout ?? const Duration(seconds: 30),
      receiveTimeout:
          normalHttpConfig?.receiveTimeout ?? const Duration(seconds: 30),
      connectTimeout:
          normalHttpConfig?.connectTimeout ?? const Duration(seconds: 30),
      headers: normalHttpConfig?.headers,
    );
    Dio dio = Dio(options);

    if (normalHttpConfig?.interceptors?.isNotEmpty ?? false) {
      dio.interceptors.addAll(normalHttpConfig!.interceptors!);
    }

    if (normalHttpConfig?.httpClientAdapter != null) {
      dio.httpClientAdapter = normalHttpConfig!.httpClientAdapter!;
    }

    if (kDebugMode && normalHttpConfig?.isNeedLog == true) {
      dio.interceptors.add(
        PrettyDioLogger(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
          request: true,
          requestBody: true,
          logPrint: (object) {
            log(object.toString());
          },
        ),
      );
    }
    return dio;
  }

  void dispose() {
    try {
      _normalDio.close(force: true);
    } catch (_) {
      // ignore
    }
  }

  static void registerSingleton(HttpClient client) {
    _singleton = client;
  }

  static HttpClient singleton() {
    final inst = _singleton;
    if (inst == null) {
      // 懒加载默认单例
      _singleton = HttpClient();
      return _singleton!;
    }
    return inst;
  }

  Future<ApiResponse> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    AbsTransformer? httpTransformer,
  }) async {
    try {
      var response = await _normalDio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return handleResponse(
        response: response,
        hzyNormalTransFormer: httpTransformer,
        caCheStatusCode: _normalHttpConfig?.cacheStatusCode ?? 304,
      );
    } on Exception catch (e) {
      return ApiResponse.fail(data: e, errorMsg: e.toString(), errorCode: -1);
    }
  }

  Future<ApiResponse> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    AbsTransformer? httpTransformer,
  }) async {
    try {
      var response = await _normalDio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return handleResponse(
        response: response,
        hzyNormalTransFormer: httpTransformer,
        caCheStatusCode: _normalHttpConfig?.cacheStatusCode ?? 304,
      );
    } on Exception catch (e) {
      return handleException(e);
    }
  }

  Future<ApiResponse> patch(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    AbsTransformer? httpTransformer,
  }) async {
    try {
      var response = await _normalDio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return handleResponse(
        response: response,
        hzyNormalTransFormer: httpTransformer,
        caCheStatusCode: _normalHttpConfig?.cacheStatusCode ?? 304,
      );
    } on Exception catch (e) {
      return handleException(e);
    }
  }

  Future<ApiResponse> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    AbsTransformer? httpTransformer,
  }) async {
    try {
      var response = await _normalDio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return handleResponse(
        response: response,
        hzyNormalTransFormer: httpTransformer,
        caCheStatusCode: _normalHttpConfig?.cacheStatusCode ?? 304,
      );
    } on Exception catch (e) {
      return handleException(e);
    }
  }

  Future<ApiResponse> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    AbsTransformer? httpTransformer,
  }) async {
    try {
      var response = await _normalDio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return handleResponse(
        response: response,
        hzyNormalTransFormer: httpTransformer,
        caCheStatusCode: _normalHttpConfig?.cacheStatusCode ?? 304,
      );
    } on Exception catch (e) {
      return handleException(e);
    }
  }

  Future<Response> download(
    String urlPath,
    savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    data,
    Options? options,
    AbsTransformer? httpTransformer,
  }) async {
    try {
      var response = await _normalDio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        options: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> uploadImage(
    String uri,
    Uint8List image, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    AbsTransformer? httpTransformer,
  }) async {
    Map<String, dynamic> map = {};
    if (queryParameters != null) {
      map.addAll(queryParameters);
    }
    map["file"] = MultipartFile.fromBytes(image, filename: "image.png");
    FormData formData = FormData.fromMap(map);
    try {
      var response = await _normalDio.post(
        uri,
        data: formData,
        options: options,
        cancelToken: cancelToken,
      );
      return handleResponse(
        response: response,
        hzyNormalTransFormer: httpTransformer,
        caCheStatusCode: _normalHttpConfig?.cacheStatusCode ?? 304,
      );
    } on Exception catch (e) {
      return handleException(e);
    }
  }
}
