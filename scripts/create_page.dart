import 'dart:io';

void main(List<String> args) {
  if (args.length < 2) {
    print('❌ 请提供模块名称和页面名称，例如：dart scripts/create_page.dart home detail');
    print('   这将会在 packages/feat_home/lib/detail/ 下生成页面文件');
    return;
  }

  final moduleName = args[0].toLowerCase();
  final pageName = args[1].toLowerCase();
  
  final packageName = 'feat_$moduleName';
  final basePath = 'packages/$packageName';
  final pagePath = '$basePath/lib/$pageName';

  final className = _toUpperCamelCase(pageName);

  print('🚀 开始在模块 $packageName 中创建页面: $pageName ...');

  if (!Directory(basePath).existsSync()) {
    print('❌ 模块不存在: $basePath');
    print('   请先使用 create_module.dart 创建模块');
    return;
  }

  if (Directory(pagePath).existsSync()) {
    print('❌ 页面目录已存在: $pagePath');
    return;
  }

  // 1. 创建目录
  _createDir(pagePath);

  // 2. 创建 State
  _createFile('$pagePath/${pageName}_state.dart', '''
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

  // 3. 创建 Controller
  _createFile('$pagePath/${pageName}_controller.dart', '''
import 'package:get/get.dart';
import 'package:lib_base/getx/controller/common_controller.dart';
import 'package:$packageName/$pageName/${pageName}_state.dart';

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

  // 4. 创建 Binding
  _createFile('$pagePath/${pageName}_binding.dart', '''
import 'package:get/get.dart';
import 'package:$packageName/$pageName/${pageName}_controller.dart';

class ${className}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ${className}Controller());
  }
}
''');

  // 5. 创建 Page
  _createFile('$pagePath/${pageName}_page.dart', '''
import 'package:flutter/material.dart';
import 'package:lib_base/getx/view/common_base_view.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:$packageName/$pageName/${pageName}_controller.dart';

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

  print('✅ 页面创建成功！');
  print('');
  print('👉 下一步操作：');
  print('  1. 在 packages/service_router/lib/router_path.dart 中添加路由路径');
  print('  2. 在 packages/$packageName/lib/${moduleName}_router.dart 中注册路由：');
  print('''
    GetPage(
      name: '/$pageName', 
      page: () => const ${className}Page(),
      binding: ${className}Binding(),
    ),
  ''');
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
  return text.split('_').map((word) {
    if (word.isEmpty) return '';
    return '${word[0].toUpperCase()}${word.substring(1)}';
  }).join('');
}
