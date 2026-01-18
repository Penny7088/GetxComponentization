
class NetException {
  final String? _errmsg;
  String get msg => _errmsg ?? runtimeType.toString();
  final int? _code;
  int get code => _code ?? -1;
  NetException([
    this._errmsg,
    this._code,
  ]);

  @override
  String toString() {
    return "code:$code--message=$msg";
  }
}

/// 客户端请求错误
class BadRequestException extends NetException {
  BadRequestException({String? message, int? code}) : super(message, code);
}

/// 服务端响应错误
class BadServiceException extends NetException {
  BadServiceException({String? message, int? code}) : super(message, code);
}

class UnKnownException extends NetException {
  UnKnownException([String? message]) : super(message);
}

class CancelException extends NetException {
  CancelException([String? message]) : super(message);
}

class NetworkException extends NetException {
  NetworkException({String? message, int? code}) : super(message, code);
}

/// 401
class UnauthorisedException extends NetException {
  UnauthorisedException({String? message, int? code = 401}) : super(message);
}

class BadResponseException extends NetException {
  dynamic data;
  BadResponseException([this.data]) : super();
}
