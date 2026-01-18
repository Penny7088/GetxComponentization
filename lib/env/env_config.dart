import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:service_core/service_core.dart'; // SocketService moved here
import 'package:yaml/yaml.dart';

/// 环境配置
class EnvironmentConfig {
  final String name;
  final String httpHost;
  final String wsHost;
  final int timeout;
  final bool debug;

  final int designWidth;
  final int designHeight;
  final int webDesignWidth;
  final int webDesignHeight;

  final String apiPrefix;
  final String cdnUrl;

  EnvironmentConfig({
    required this.name,
    required this.httpHost,
    required this.wsHost,
    required this.timeout,
    required this.debug,
    this.designWidth = 375,
    this.designHeight = 667,
    this.webDesignWidth = 1440,
    this.webDesignHeight = 900,
    this.apiPrefix = '',
    this.cdnUrl = '',
  });

  factory EnvironmentConfig.fromMap(Map<String, dynamic> map) {
    return EnvironmentConfig(
      name: map['name'] ?? '',
      httpHost: map['http_host'] ?? '',
      wsHost: map['ws_host'] ?? '',
      timeout: map['timeout'] ?? 60,
      debug: map['debug'] ?? false,
      designWidth: map['design_width'] ?? 375,
      designHeight: map['design_height'] ?? 667,
      webDesignWidth: map['web_design_width'] ?? 1440,
      webDesignHeight: map['web_design_height'] ?? 900,
      apiPrefix: map['api_prefix'] ?? '',
      cdnUrl: map['cdn_url'] ?? '',
    );
  }

  /// 获取 HTTP 基础 URL
  String get httpBaseUrl {
    final prefix = apiPrefix.isNotEmpty ? apiPrefix : '';
    return 'https://$httpHost$prefix';
  }

  /// 获取 WebSocket 基础 URL
  String get wsBaseUrl => 'wss://$wsHost';
}

/// 环境配置管理器
class EnvConfig {
  static EnvConfig? _instance;
  static EnvConfig get instance => _instance ??= EnvConfig._();

  EnvConfig._();

  Map<String, EnvironmentConfig> _environments = {};
  late String _defaultEnvironment;

  /// 初始化配置
  static Future<void> initialize() async {
    await instance._loadConfig();
  }

  /// 加载配置文件
  Future<void> _loadConfig() async {
    try {
      final configString = await rootBundle.loadString(
        'assets/config/env_config.yaml',
      );
      final yamlMap = loadYaml(configString);
      final config = Map<String, dynamic>.from(yamlMap);

      // 解析环境配置
      final environments = Map<String, dynamic>.from(
        config['environments'] ?? {},
      );
      _environments = environments.map(
        (key, value) => MapEntry(
          key,
          EnvironmentConfig.fromMap(Map<String, dynamic>.from(value)),
        ),
      );

      // 解析默认环境，优先使用编译时参数，其次使用配置文件，最后回退到 'test'
      final envParam = const String.fromEnvironment('ENVIRONMENT');
      final yamlDefault = config['default_environment'] ?? 'test';
      final resolvedDefault = envParam.isNotEmpty ? envParam : yamlDefault;
      _defaultEnvironment = _environments.containsKey(resolvedDefault)
          ? resolvedDefault
          : 'test';

      debugPrint('EnvConfig loaded successfully');
      debugPrint('Environments: ${_environments.keys.toList()}');
      debugPrint('Default environment: $_defaultEnvironment');
    } catch (e) {
      debugPrint('Error loading env config: $e');
      // 设置默认值以防配置文件加载失败
      _setDefaultConfig();
    }
  }

  /// 设置默认配置（配置文件加载失败时使用）
  void _setDefaultConfig() {
    _environments = {
      'test': EnvironmentConfig(
        name: '测试环境',
        httpHost: 'api-test.t-pro.vip',
        wsHost: 'api-test.t-pro.vip',
        timeout: 60,
        debug: true,
      ),
      'production': EnvironmentConfig(
        name: '生产环境',
        httpHost: 'node.tmaxkks.xyz',
        wsHost: 'node.tmaxkks.xyz',
        timeout: 60,
        debug: false,
      ),
    };
    _defaultEnvironment = 'test';
  }

  /// 获取当前环境配置
  EnvironmentConfig getCurrentEnvironment() {
    debugPrint('getCurrentEnvironment:$_defaultEnvironment');
    final env = _environments[_defaultEnvironment] ?? _environments['test'];
    return env!;
  }

  /// 获取指定环境配置
  EnvironmentConfig? getEnvironment(String key) {
    return _environments[key];
  }

  /// 获取所有环境
  Map<String, EnvironmentConfig> get environments => _environments;

  /// 是否为测试模式
  bool get testMode {
    // 优先从编译时参数获取
    debugPrint('testMode = $_defaultEnvironment');
    if (_defaultEnvironment == 'test') return true;

    // 根据当前环境判断
    final currentEnv = getCurrentEnvironment();
    return currentEnv.debug;
  }

  /// 获取 HTTP 基础 URL
  String get httpBaseUrl => getCurrentEnvironment().httpBaseUrl;

  /// 获取 WebSocket 基础 URL
  String get wsBaseUrl => getCurrentEnvironment().wsBaseUrl;

  /// 获取超时时间
  int get timeout => getCurrentEnvironment().timeout;

  /// 是否为调试模式
  bool get isDebug => getCurrentEnvironment().debug;

  /// 获取当前环境名称
  String get environmentName => getCurrentEnvironment().name;

  /// 获取 CDN 基础 URL
  String get cdnBaseUrl => getCurrentEnvironment().cdnUrl;

  /// 获取设计稿尺寸
  Size get designSize => Size(
    getCurrentEnvironment().designWidth.toDouble(),
    getCurrentEnvironment().designHeight.toDouble(),
  );

  /// 获取 Web 端设计稿尺寸
  Size get webDesignSize => Size(
    getCurrentEnvironment().webDesignWidth.toDouble(),
    getCurrentEnvironment().webDesignHeight.toDouble(),
  );

  void updateHosts({required String httpUrl, required String wsUrl}) {
    try {
      final current = getCurrentEnvironment();

      String newHttpHost = httpUrl;
      if (httpUrl.contains('://')) {
        final uri = Uri.parse(httpUrl);
        newHttpHost = uri.host + (uri.hasPort ? ':${uri.port}' : '');
      }

      String newWsHost = wsUrl;
      if (wsUrl.contains('://')) {
        final uri = Uri.parse(wsUrl);
        newWsHost = uri.host + (uri.hasPort ? ':${uri.port}' : '');
      }

      String targetKey = _defaultEnvironment;
      if (!_environments.containsKey(targetKey)) {
        targetKey = 'test';
      }

      if (_environments.containsKey(targetKey)) {
        // 更新内存中的配置
        _environments[targetKey] = EnvironmentConfig(
          name: current.name,
          httpHost: newHttpHost,
          wsHost: newWsHost,
          timeout: current.timeout,
          debug: current.debug,
          designWidth: current.designWidth,
          designHeight: current.designHeight,
          webDesignWidth: current.webDesignWidth,
          webDesignHeight: current.webDesignHeight,
          apiPrefix: current.apiPrefix,
          cdnUrl: current.cdnUrl,
        );
        debugPrint(
          'EnvConfig updated: httpHost=$newHttpHost, wsHost=$newWsHost',
        );

        // 同步更新 SocketService 的连接
        if (Get.isRegistered<SocketService>()) {
          // 注意：EnvironmentConfig.wsBaseUrl 会自动拼装 wss:// 前缀
          // 这里我们直接使用 getter 获取最新的完整 wsUrl
          Get.find<SocketService>().updateBaseUrl(wsBaseUrl);
        }
      }
    } catch (e) {
      debugPrint('Error updating EnvConfig hosts: $e');
    }
  }
}
