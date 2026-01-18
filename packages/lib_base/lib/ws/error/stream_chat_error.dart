import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:lib_base/http/http_response.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'ws_error_code.dart';

///
class WsError with EquatableMixin implements Exception {
  ///
  const WsError(this.message);

  /// Error message
  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'WsError(message: $message)';
}

///
class WsSocketError extends WsError {
  ///
  const WsSocketError(super.message, {this.data});

  ///
  factory WsSocketError.fromStreamError(Map<String, Object?> error) {
    final data = ApiResponse.fromJson(error);
    final message = data.msg ?? '';
    return WsSocketError(message, data: data);
  }

  ///
  factory WsSocketError.fromWebSocketChannelError(
    WebSocketChannelException error,
  ) {
    final message = error.message ?? '';
    return WsSocketError(message);
  }

  ///
  int? get code {
    final codeStr = data?.code;
    if (codeStr != null) {
      return int.tryParse(codeStr.toString());
    }
    return null;
  }

  ///
  WsErrorCode? get errorCode {
    final code = this.code;
    if (code == null) return null;
    return wsErrorCodeFromCode(code);
  }

  /// Response body. please refer to [ErrorResponse].
  final ApiResponse? data;

  ///
  bool get isRetriable => data == null;

  @override
  List<Object?> get props => [...super.props, code];

  @override
  String toString() {
    var params = 'message: $message';
    if (data != null) params += ', data: $data';
    return 'WsSocketError($params)';
  }
}

///
class WsNetworkError extends WsError {
  ///
  WsNetworkError(
    WsErrorCode errorCode, {
    int? statusCode,
    this.data,
    this.isRequestCancelledError = false,
  }) : code = errorCode.code,
       statusCode = statusCode ?? int.tryParse(data?.code.toString() ?? ''),
       super(errorCode.message);

  ///
  WsNetworkError.raw({
    required this.code,
    required String message,
    this.statusCode,
    this.data,
    this.isRequestCancelledError = false,
  }) : super(message);

  ///
  factory WsNetworkError.fromDioException(DioException exception) {
    final response = exception.response;
    ApiResponse? errorResponse;
    final data = response?.data;
    if (data is Map<String, Object?>) {
      errorResponse = ApiResponse.fromJson(data);
    } else if (data is String) {
      errorResponse = ApiResponse.fromJson(jsonDecode(data));
    }

    int? parsedCode;
    if (errorResponse?.code != null) {
      parsedCode = int.tryParse(errorResponse!.code!.toString());
    }

    return WsNetworkError.raw(
      code: parsedCode ?? -1,
      message:
          errorResponse?.msg ??
          response?.statusMessage ??
          exception.message ??
          '',
      statusCode: parsedCode ?? response?.statusCode,
      data: errorResponse,
      isRequestCancelledError: exception.type == DioExceptionType.cancel,
    )..stackTrace = exception.stackTrace;
  }

  /// Error code
  final int code;

  /// HTTP status code
  final int? statusCode;

  /// Response body. please refer to [ErrorResponse].
  final ApiResponse? data;

  /// True, in case the error is due to a cancelled network request.
  final bool isRequestCancelledError;

  StackTrace? _stackTrace;

  ///
  set stackTrace(StackTrace? stack) => _stackTrace = stack;

  ///
  WsErrorCode? get errorCode => wsErrorCodeFromCode(code);

  ///
  bool get isRetriable => data == null;

  @override
  List<Object?> get props => [...super.props, code, statusCode];

  @override
  String toString({bool printStackTrace = false}) {
    var params = 'code: $code, message: $message';
    if (statusCode != null) params += ', statusCode: $statusCode';
    if (data != null) params += ', data: $data';
    var msg = 'WsNetworkError($params)';

    if (printStackTrace && _stackTrace != null) {
      msg += '\n$_stackTrace';
    }
    return msg;
  }
}
