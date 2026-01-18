import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';

import 'http_parse.dart';
import 'http_response.dart';
import 'path_provider_tool.dart';

/// 网络请求缓存策略
class DioCacheTool {
  DioCacheTool._();
  static CacheOptions? cacheOptions;
  static CacheStore? cacheStore;

  /*
   * 初始化缓存配置项  
  */
  static initCacheStore() async {
    String? path = await PathProviderTool.getTemPath();
    cacheStore = HiveCacheStore(path, hiveBoxName: "chat_project_http_cache");
    return cacheStore;
  }

  /*
   * 初始化缓存拦截器 
  */
  static DioCacheInterceptor init() {
    cacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.request,
      allowPostMethod: true,
    );
    return DioCacheInterceptor(options: cacheOptions!);
  }

  /*
   * 获取缓存数据 
   * dio_cache 原始数据
   * */
  static getHttpCacheResponse({
    required String path,
    String? method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final key = CacheOptions.defaultCacheKeyBuilder(
      RequestOptions(
        path: path,
        method: method,
        data: data,
        queryParameters: queryParameters,
      ),
    );
    return await cacheStore?.get(key);
  }

  /*
   * 获取缓存数据
   * 转换成项目使用模型
  */
  static Future<ApiResponse?> getHzyNormalResponse({
    required String path,
    String? method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    CacheResponse? res = await getHttpCacheResponse(
      path: path,
      method: method,
      data: data,
      queryParameters: queryParameters,
    );

    if (res != null) {
      var response = res.toResponse(
        RequestOptions(
          path: path,
          method: method,
          data: data,
          queryParameters: queryParameters,
        ),
      );

      return handleResponse(response: response);
    } else {
      return null;
    }
  }

  /*
   * 清楚http缓存 
  */
  static clearHttpCache() async {
    await cacheStore?.clean();
  }

  /*
   * 清理单个网络请求缓存
  */
  static clearUrlHttpCache({required String url}) async {
    final key = CacheOptions.defaultCacheKeyBuilder(RequestOptions(path: url));
    await cacheStore?.delete(key);
  }
}
