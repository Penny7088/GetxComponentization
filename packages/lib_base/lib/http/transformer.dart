import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:lib_base/utils/extensions/string_extensions.dart';

import 'http_response.dart';

abstract class AbsTransformer {
  ApiResponse parse(Response response);
}

///Http配置.
class HttpResponseConfig {
  /// constructor.
  HttpResponseConfig({this.code, this.msg, this.data});

  /// BaseResp [int code]字段 key, 默认：errorCode.
  String? code;

  /// BaseResp [String msg]字段 key, 默认：errorMsg.
  dynamic msg;

  /// BaseResp [T data]字段 key, 默认：data.
  String? data;
}

class NormalDefaultTransformer extends AbsTransformer {
  final String _codeKey = "code";
  final String _msgKey = 'msg';
  final String _dataKey = "data";

  // 支持多种成功状态码：字符串 "succeed" 或 数字 200/0
  final List<dynamic> _successCodes = ["succeed", 200, 0];
  final String _errorCode = "error"; //请求失败

  @override
  ApiResponse parse(Response response) {
    // 原始响应体
    final dynamic raw = response.data;
    if (raw == null) {
      return ApiResponse.fail(data: null, errorMsg: '返回数据为空', errorCode: -1);
    }
    // 兼容 String/Map 的解析，并对 JSON 解析错误做保护
    dynamic jsonContent = raw;
    if (jsonContent is String) {
      if (jsonContent.isEmpty) {
        return ApiResponse.fail(
          data: jsonContent,
          errorMsg: '返回数据为空',
          errorCode: -1,
        );
      }
      try {
        jsonContent = json.decode(jsonContent);
      } catch (e) {
        debugPrint('JSON Decode Error: $e');
        return ApiResponse.fail(
          data: raw,
          errorMsg: '返回数据解析失败: $e',
          errorCode: -1,
        );
      }
    }
    if (jsonContent is! Map) {
      return ApiResponse.fail(
        data: jsonContent,
        errorMsg: '返回数据格式错误',
        errorCode: -1,
      );
    }
    var code = jsonContent[_codeKey];
    //返回的数据结构中， code 为空
    if (code == null) {
      return ApiResponse.fail(
        data: jsonContent,
        errorMsg: '返回code为空',
        errorCode: -1,
      );
    }
    //返回的数据结构中， code 是字符串
    if (code is String) {
      //判断返回的code是否合法
      if (_successCodes.contains(code)) {
        return ApiResponse.success(
          netData: jsonContent[_dataKey] ?? jsonContent,
          reqMsg: jsonContent[_msgKey],
        );
      } else if (code == _errorCode) {
        // 请求失败
        return ApiResponse.fail(
          errorMsg: (jsonContent[_msgKey] != null) ? jsonContent[_msgKey] : "",
          errorCode: -1,
          data: jsonContent[_dataKey] ?? jsonContent,
        );
      } else {
        return ApiResponse.fail(
          errorMsg: (jsonContent[_msgKey] != null) ? jsonContent[_msgKey] : "",
          errorCode: int.tryParse(code) ?? -1,
          data: jsonContent[_dataKey] ?? jsonContent,
        );
      }
    }

    // 返回的数据结构中，code 是数字
    if (code is int) {
      if (_successCodes.contains(code)) {
        return ApiResponse.success(
          netData: jsonContent[_dataKey] ?? jsonContent,
          reqMsg: jsonContent[_msgKey],
        );
      }
    }

    return ApiResponse.fail(
      errorMsg: (jsonContent[_msgKey] != null) ? jsonContent[_msgKey] : "",
      errorCode: code is int ? code : -1,
      data: jsonContent[_dataKey] ?? jsonContent,
    );
  }

  /// 单例对象
  static final NormalDefaultTransformer _instance =
      NormalDefaultTransformer._internal();

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  NormalDefaultTransformer._internal();

  /// 工厂构造方法，这里使用命名构造函数方式进行声明
  factory NormalDefaultTransformer.getInstance() => _instance;
}
