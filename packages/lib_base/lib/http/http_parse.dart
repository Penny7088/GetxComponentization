
import 'dart:io';

import 'package:dio/dio.dart';

import 'transformer.dart';
import 'exception.dart';
import 'http_response.dart';

ApiResponse handleResponse({
  Response? response,
  AbsTransformer? hzyNormalTransFormer,
  int caCheStatusCode = 304,
}) {
  hzyNormalTransFormer ??= NormalDefaultTransformer.getInstance();

  if (response == null) {
    return ApiResponse.fail(
      data: response,
      errorMsg: '请求的数据为空',
      errorCode: -1,
    );
  }

  if (_isTokenTimeout(response.statusCode)) {
    return ApiResponse.failureFromError(
      UnauthorisedException(
        message: "没有权限",
        code: response.statusCode,
      ),
    );
  }

  // 接口调用成功
  if (_isRequestSuccess(
    response.statusCode,
    caCheStatusCode,
  )) {
    return hzyNormalTransFormer.parse(response);
  } else {
    // 接口调用失败
    return ApiResponse.fail(
      errorMsg: response.statusMessage,
      errorCode: response.statusCode,
      data: response,
    );
  }
}

ApiResponse handleException(Exception exception) =>
    ApiResponse.failureFromError(_parseException(exception));

/// 鉴权失败
bool _isTokenTimeout(int? code) {
  return code == 401;
}

/// 请求成功
bool _isRequestSuccess(int? statusCode, int caCheStatusCode) {
  return ((statusCode != null && statusCode >= 200 && statusCode < 300) ||
      statusCode == caCheStatusCode);
}

NetException _parseException(Exception error) {
  if (error is DioException) {
    try {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return NetworkException(message: "网络连接超时");
        case DioExceptionType.sendTimeout:
          return NetworkException(message: "请求发送超时");
        case DioExceptionType.receiveTimeout:
          return NetworkException(message: "数据接收超时");
        case DioExceptionType.badCertificate:
          return NetworkException(message: "证书不正确");
        case DioExceptionType.cancel:
          return CancelException(error.message);

        case DioExceptionType.badResponse:
          int? errCode = error.response?.statusCode;
          switch (errCode) {
            case 400:
              return BadRequestException(message: "请求语法错误", code: errCode);
            case 401:
              return BadRequestException(message: "没有权限", code: errCode);
            case 403:
              return BadRequestException(message: "服务器拒绝执行", code: errCode);
            case 404:
              return BadRequestException(message: "无法连接服务器", code: errCode);
            case 405:
              return BadRequestException(message: "请求方法被禁止", code: errCode);
            case 500:
              return BadServiceException(message: "服务器内部错误", code: errCode);
            case 502:
              return BadServiceException(message: "无效的请求", code: errCode);
            case 503:
              return BadServiceException(message: "服务器挂了", code: errCode);
            case 505:
              return UnauthorisedException(
                  message: "不支持HTTP协议请求", code: errCode);
            default:
              return UnKnownException(error.message);
          }
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return NetworkException(message: error.message);
          } else {
            return UnKnownException(error.message);
          }
        default:
          return UnKnownException(error.message);
      }
    } catch (e) {
      return UnKnownException(error.toString());
    }
  } else {
    // 非 Dio 异常，明确处理常见的解析错误
    if (error is FormatException) {
      return BadServiceException(message: "返回数据解析失败");
    }
    return UnKnownException(error.toString());
  }
}
