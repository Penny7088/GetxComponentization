import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:lib_base/utils/extensions/locale_extension.dart';

class HeaderInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    var platformType = "0"; // 固定为2（对应Java端定义）
    var deviceId = ""; // 从deviceInfo获取设备ID
    // 获取设备信息
    final deviceInfoPlugin = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();
    // 2. 声明osVersion变量（避免重复声明）
    String osVersion, phoneType;
    // 3. 根据当前平台异步获取设备信息，手机型号
    if (defaultTargetPlatform == TargetPlatform.android) {
      // Android平台：获取Android设备信息
      platformType = "2"; // 固定为2
      final androidInfo = await deviceInfoPlugin.androidInfo;
      deviceId = androidInfo.id;
      osVersion =
          'Android ${androidInfo.version.release}'; // Android系统版本（如"13"）
      phoneType =
          'Android, ${androidInfo.manufacturer} ${androidInfo.model} ${androidInfo.product}';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // iOS平台：获取iOS设备信息
      platformType = "1"; // 固定为1
      final iosInfo = await deviceInfoPlugin.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? '';
      osVersion = 'iOS ${iosInfo.systemVersion}'; // iOS系统版本（如"16.4"）
      phoneType = 'iPhone, ${iosInfo.name} ${iosInfo.model}';
    } else {
      // 其他平台默认值
      osVersion = "Other";
      phoneType = "Other";
    }
    // 基础信息
    final appVersion = packageInfo.version;
    // final machineModel = androidInfo.model;

    final clientTime = DateTime.now().millisecondsSinceEpoch;

    // 获取语言
    // final acceptLanguage = AppService.to.userManager.preferences.currentLocal
    //     .toHttpLanguageCode();
    // 构建基础头信息
    final Map<String, String> headers = {
      // 'token': AppService.to.userManager.userInfo.token ?? '', // 从UserManager获取
      // 'Accept-Language': acceptLanguage,
      'deviceId': deviceId, // 设备唯一标识（需注意Android 10+的限制）
      'appVersion': appVersion,
      'platformType': platformType,
      'osVersion': osVersion,
      'clientTime': clientTime.toString(),
      'phoneType': phoneType.toString(),
    };

    // 生成签名
    final sign = await _getSign(options, headers);
    options.headers.addAll({...headers, 'sign': sign});
    return handler.next(options);
  }

  Future<String> _getSign(
    RequestOptions options,
    Map<String, String> headers,
  ) async {
    final treeMap = <String, String>{};
    // 添加请求头到排序Map
    headers.forEach((key, value) => treeMap[key] = value);

    // 处理不同请求方法的参数
    if (['GET', 'DELETE'].contains(options.method.toUpperCase())) {
      // 处理GET/DELETE的查询参数
      options.queryParameters.forEach((key, value) {
        treeMap[key] = value.toString();
      });
    } else if (['POST', 'PUT'].contains(options.method.toUpperCase())) {
      // 处理POST/PUT的请求体（示例仅处理JSON格式）
      if (options.data != null) {
        String bodyStr;
        if (options.data is Map) {
          bodyStr = jsonEncode(options.data);
        } else if (options.data is FormData) {
          // 处理FormData（需根据实际需求扩展）
          bodyStr = options.data.toString();
        } else {
          bodyStr = options.data.toString();
        }
        // 去除空格/换行（Java正则移植）
        bodyStr = bodyStr.replaceAll(RegExp(r'\s+'), '');
        treeMap['body'] = bodyStr; // 用固定key存储请求体内容
      }
    }

    // 按键排序并拼接字符串
    final sortedKeys = treeMap.keys.toList()..sort();
    final signStr = sortedKeys.map((key) => "$key=${treeMap[key]}").join('');

    // MD5加密（Java StringUtils.md5移植）
    final bytes = utf8.encode(signStr);
    final digest = md5.convert(bytes);
    return digest.toString();
  }
}
