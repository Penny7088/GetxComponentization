import 'package:dio/dio.dart';
import 'package:lib_base/utils/crypto_utils.dart';

/// 加解密拦截器
class CryptoInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 1. 只有 POST/PUT/PATCH 请求且有数据时才加密
    //    或者根据自定义 Header 判断是否需要加密
    if (options.data != null && 
       (options.method == 'POST' || options.method == 'PUT' || options.method == 'PATCH')) {
       
       // 假设后端要求上传加密后的字符串，放在 data 字段中，或者直接替换 data
       // 这里演示直接替换 data 为加密字符串
       final encrypted = CryptoUtils.encryptData(options.data);
       options.data = encrypted;
       
       // 告诉后端内容类型
       // options.headers['Content-Type'] = 'text/plain'; 
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 2. 解密响应数据
    //    假设后端返回的是加密后的 Base64 字符串
    if (response.data is String) {
      final decrypted = CryptoUtils.decryptData(response.data);
      if (decrypted != null) {
        response.data = decrypted;
      }
    }
    super.onResponse(response, handler);
  }
}
