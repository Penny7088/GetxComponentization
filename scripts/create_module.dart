import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('❌ 请提供模块名称，例如：dart scripts/create_module.dart profile');
    return;
  }

  final name = args[0].toLowerCase();
  final className = _toUpperCamelCase(name);
  final packageName = 'feat_$name';
  final basePath = 'packages/$packageName';

  print('🚀 开始创建模块: $packageName ...');

  if (Directory(basePath).existsSync()) {
    print('❌ 模块已存在: $basePath');
    return;
  }

  // 1. 创建目录结构
  _createDir('$basePath/lib/$name');
  _createDir('$basePath/assets/images/svg/dark');
  _createDir('$basePath/assets/images/svg/light');
  _createDir('$basePath/assets/images/light');
  _createDir('$basePath/assets/images/dark');
  _createDir('$basePath/assets/json');

  // 2. 创建 pubspec.yaml
  _createFile('$basePath/pubspec.yaml', '''
name: $packageName
description: $className feature module
version: 1.0.0
publish_to: 'none'

environment:
  sdk: ^3.8.1

dependencies:
  flutter:
    sdk: flutter
  get: ^4.7.3
  
  lib_base:
    path: ../lib_base
  lib_uikit:
    path: ../lib_uikit
  service_router:
    path: ../service_router

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/images/light
    - assets/images/dark
    - assets/images/svg/light
    - assets/images/svg/dark
    - assets/images/svg/common
    - assets/json/
''');

  // 3. 创建 State
  _createFile('$basePath/lib/$name/${name}_state.dart', '''
import 'package:lib_base/getx/state/base_state.dart';

class ${className}State extends BaseState {
  ${className}State() {
    // Initialize state properties here
    isNeedScaffold = true;
    isShowAppBar = true;
    appBarTitle = "$className";
  }

  @override
  void release() {
    // Clean up resources
  }
}
''');

  // 4. 创建 Controller
  _createFile('$basePath/lib/$name/${name}_controller.dart', '''
import 'package:get/get.dart';
import 'package:lib_base/getx/controller/common_controller.dart';
import 'package:$packageName/$name/${name}_state.dart';

class ${className}Controller extends CommonController<${className}State> {
  @override
  ${className}State createState() {
    return ${className}State();
  }

  @override
  void onInit() {
    super.onInit();
  }
}
''');

  // 5. 创建 Binding
  _createFile('$basePath/lib/$name/${name}_binding.dart', '''
import 'package:get/get.dart';
import 'package:$packageName/$name/${name}_controller.dart';

class ${className}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ${className}Controller());
  }
}
''');

  // 6. 创建 Page
  _createFile('$basePath/lib/$name/${name}_page.dart', '''
import 'package:flutter/material.dart';
import 'package:lib_base/getx/view/common_base_view.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:$packageName/$name/${name}_controller.dart';

class ${className}Page extends CommonBaseView<${className}Controller> {
  const ${className}Page({super.key});

  @override
  Widget createContentBody({
    required BuildContext context,
    BoxConstraints? constraints,
  }) {
    return Center(
      child: AppText.heading('${className} Page'),
    );
  }
}
''');

  // 7. 创建 Router
  _createFile('$basePath/lib/${name}_router.dart', '''
import 'package:get/get.dart';
// import 'package:service_router/service_router.dart'; // Uncomment when RouterPath is updated
import 'package:$packageName/$name/${name}_binding.dart';
import 'package:$packageName/$name/${name}_page.dart';

class ${className}Router {
  static List<GetPage> routers = [
    GetPage(
      name: '/$name', // TODO: Add RouterPath.$name in service_router
      page: () => const ${className}Page(),
      binding: ${className}Binding(),
    ),
  ];
}
''');

  print('✅ 模块创建成功！');
  print('');
  print('👉 下一步操作：');
  print(
    '  1. 在 packages/service_router/lib/router_path.dart 中添加: static const String $name = "/$name";',
  );
  print(
    '  2. 在根目录 pubspec.yaml 中添加依赖: $packageName: path: packages/$packageName',
  );
  print('  3. 运行: dart run melos bootstrap');
  print(
    '  4. 在 lib/router/app_router.dart 中注册: ...${className}Router.routers,',
  );
  print('');
}

void _createDir(String path) {
  Directory(path).createSync(recursive: true);
  print('  Created dir: $path');
}

void _createFile(String path, String content) {
  File(path).writeAsStringSync(content);
  print('  Created file: $path');
}

String _toUpperCamelCase(String text) {
  return text
      .split('_')
      .map((word) {
        if (word.isEmpty) return '';
        return '${word[0].toUpperCase()}${word.substring(1)}';
      })
      .join('');
}
