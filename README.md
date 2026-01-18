# Flutter Bit Beat - 组件化架构工程

本项目采用 **Flutter 组件化架构** 开发，旨在实现高内聚、低耦合的代码结构，支持多团队并行开发与独立维护。

## 🏗 架构概览

项目整体架构分为四层，自上而下分别为：

1.  **壳工程 (App Shell)**
    *   位置: `lib/` (根目录)
    *   职责: 应用入口、依赖聚合 (`AppRouter`, `AppBinding`)。
    *   它不包含具体业务逻辑，仅负责将各个积木（业务模块）组装成一个完整的 App。

2.  **业务层 (Feature Layer)**
    *   位置: `packages/feat_xxx`
    *   职责: 具体的业务功能实现，如首页、交易、行情等。
    *   **原则**: 业务模块之间**严禁直接相互引用**。所有通信必须通过服务层进行。
    *   现有模块:
        *   `feat_home`: 首页
        *   `feat_trade`: 交易
        *   `feat_market`: 行情
        *   `feat_wallet`: 资产/钱包
        *   `feat_favorites`: 自选
        *   `feat_onboarding`: 引导页与登录
        *   `feat_splash`: 启动页
        *   `feat_main`: 主容器 (BottomNavigationBar)

3.  **核心服务层 (Service Core Layer)**
    *   位置: `packages/service_core`
    *   职责: **核心业务中台**，提供全局共享的业务逻辑和服务。
    *   包含内容:
        *   **AuthService**: 用户认证、Token 管理。
        *   **ConfigService**: 全局配置管理。
        *   **ThemeService**: 主题切换服务。
        *   **LanguageService**: 多语言切换服务。
        *   **SocketService**: WebSocket 长连接服务。
    *   **特点**: 所有 `feat_` 业务模块都依赖此模块，以获取全局能力。

4.  **接口层 (Service Router Layer)**
    *   位置: `packages/service_router`
    *   职责: 模块间通信的中枢。
    *   包含内容:
        *   **RouterPath**: 统一路由表。
        *   **EventBus**: 跨模块事件总线。
        *   **Interfaces**: 跨模块服务接口定义 (如 `IUserService`)。

5.  **基础层 (Foundation Layer)**
    *   位置: `packages/lib_base` 和 `packages/lib_uikit`
    *   职责: 提供通用能力。
    *   `lib_base`: 纯粹的底层能力，如 HTTP/WS 协议封装、工具类、基础 Model、存储、GetX 封装等。**不含任何业务逻辑**。
    *   `lib_uikit`: 通用 UI 组件、主题资源、字体、图标、多语言资源。**不含业务状态管理**。

---

## 🚀 快速开始

### 环境准备

*   Flutter SDK: `^3.8.1`
*   Melos: 全局安装 `dart pub global activate melos`

### 初始化项目

```bash
# 1. 获取依赖
flutter pub get

# 2. 初始化所有子包 (重要！)
dart run melos bootstrap
```

### 运行

```bash
flutter run
```

---

## 📡 模块通信指南

由于业务模块之间物理隔离，请严格遵守以下通信规范：

### 1. 页面跳转 (Routing)

所有路由路径定义在 `packages/service_router/lib/router_path.dart`。

```dart
import 'package:service_router/service_router.dart';
import 'package:get/get.dart';

// 跳转到交易页面
Get.toNamed(RouterPath.trade);
```

### 2. 事件通知 (EventBus)

用于模块间的解耦通知（例如：登录成功后通知首页刷新）。

```dart
import 'package:service_router/service_router.dart';

// 1. 定义事件 (建议放在 service_router/lib/event/ 或业务包内部)
class LoginSuccessEvent extends AppEvent {}

// 2. 发送事件
EventBus.instance.fire(LoginSuccessEvent());

// 3. 监听事件
EventBus.instance.on<LoginSuccessEvent>().listen((event) {
  // 处理逻辑
});
```

### 3. 获取全局服务 (Service Core)

当需要访问全局状态（如用户信息、主题、配置）时，直接通过 `service_core` 获取。

```dart
import 'package:service_core/service_core.dart';
import 'package:get/get.dart';

// 1. 获取 Auth 服务
final authService = Get.find<IUserService>();
print(authService.userId);

// 2. 切换主题
ThemeService.to.setTheme(ThemeMode.dark);

// 3. 切换语言
Get.find<LanguageService>().setLocale(const Locale('zh', 'CN'));
```

---

## 🧩 如何创建新模块

本项目提供了自动化脚本来快速生成标准化的业务模块。

### Step 1: 运行生成脚本

在项目根目录下执行：

```bash
# 语法: dart scripts/create_module.dart <module_name>
dart scripts/create_module.dart profile
```

该脚本会自动：
1.  在 `packages/` 下创建 `feat_profile`。
2.  生成 `pubspec.yaml` 并配置基础依赖（自动包含 `service_core`）。
3.  生成标准的 MVVM 文件 (`Page`, `Controller`, `Binding`, `State`)。
4.  生成路由文件 (`profile_router.dart`)。
5.  创建资源目录 (`assets/images`, `assets/json`)。

### Step 2: 注册到壳工程

脚本执行完毕后，请按照控制台提示完成以下注册步骤：

1.  **添加常量**: 在 `packages/service_router/lib/router_path.dart` 中定义路由路径。
2.  **添加依赖**: 在根目录 `pubspec.yaml` 中添加：
    ```yaml
    dependencies:
      feat_profile:
        path: packages/feat_profile
    ```
3.  **链接包**: 运行 `dart run melos bootstrap`。
4.  **注册路由**: 在 `lib/router/app_router.dart` 中添加：
    ```dart
    static List<GetPage> getAllRoutS() {
      return [
        ...MainRouter.routers,
        ...ProfileRouter.routers, // 新增
      ];
    }
    ```

---

## 🛠 常用命令

本项目使用 **Melos** 管理多包工程。

*   `dart run melos bootstrap`: 链接所有本地包并安装依赖。
*   `dart run melos clean`: 清理所有包的构建产物。
*   `dart run melos analyze`: 对所有包执行静态分析。
*   `dart run melos format`: 格式化所有代码。
*   `dart run melos test`: 运行测试（仅针对包含 test 目录的包）。

## 📏 开发规范

### 依赖管理

*   **lib_base**: 仅包含底层能力依赖（如 `dio`, `hive`, `web_socket_channel`）。
*   **lib_uikit**: 包含 UI 相关依赖（如 `flutter_screenutil`, `flutter_svg`, `lottie`）。
*   **service_core**: 包含全局业务逻辑依赖。
*   **业务模块**: 依赖 `service_core`、`lib_uikit`、`service_router`。原则上不直接依赖第三方库，除非是该模块特有的。

### 环境配置 (Environment)

本项目采用 YAML 配置文件管理多环境差异。

*   **配置文件位置**: `assets/config/env_config.yaml`
*   **配置类**: `lib/env/env_config.dart`
*   **切换环境**:
    *   方式 1: 修改 YAML 文件中的 `default_environment`。
    *   方式 2: 编译时指定参数: `flutter run --dart-define=ENVIRONMENT=production`

## 📂 目录结构详情

```text
flutter_bit_beat/
├── lib/                        # [壳工程]
│   ├── env/                    # 环境配置实现
│   ├── router/                 # 路由聚合
│   ├── main.dart               # App 入口
│   └── app_binding.dart        # 全局依赖注入
├── packages/                   # [子工程集合]
│   ├── lib_base/               # 基础库 (纯底层能力)
│   ├── lib_uikit/              # UI 库 (组件, 资源)
│   ├── service_router/         # 接口层 (路由, EventBus, 接口定义)
│   ├── service_core/           # 核心业务层 (Auth, Config, Socket, Theme, i18n)
│   ├── feat_home/              # 业务模块: 首页
│   ├── feat_trade/             # 业务模块: 交易
│   └── ...                     # 其他业务模块
├── assets/                     # 全局资源 (配置等)
└── pubspec.yaml                # 壳工程配置
```
