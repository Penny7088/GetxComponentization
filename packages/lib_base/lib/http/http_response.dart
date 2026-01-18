import 'exception.dart';

class ApiResponse<T> {
  late bool ok;
  dynamic data;
  String? msg;
  int? code;
  NetException? error;

  ApiResponse.fromJson(dynamic json) {
    data = json['data'];
    msg = json['msg'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    return {'data': data, 'msg': msg, 'code': code};
  }

  ApiResponse.success({
    required dynamic netData,
    Map<String, dynamic>? response,
    String? reqMsg,
  }) {
    data = netData;
    msg = reqMsg;
    ok = true;
  }

  ApiResponse.fail({
    required this.data,
    String? errorMsg = '网络请求失败',
    int? errorCode = 404,
    Map<String, dynamic>? response,
  }) {
    msg = errorMsg;
    error = NetException(msg, errorCode);
    ok = false;
  }

  ApiResponse.failureFormResponse({dynamic data}) {
    error = BadResponseException();
    ok = false;
  }

  ApiResponse.failureFromError([NetException? requestError]) {
    error = requestError ?? UnKnownException();
    ok = false;
  }
}
