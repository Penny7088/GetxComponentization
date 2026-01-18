import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_base/getx/view/common_base_view.dart';
import 'package:service_router/service_router.dart';
// import 'package:lib_uikit/lib_uikit.dart';
import 'communication_demo_controller.dart';

class CommunicationDemoPage
    extends CommonBaseView<CommunicationDemoController> {
  const CommunicationDemoPage({Key? key}) : super(key: key);

  @override
  Widget createContentBody({
    required BuildContext context,
    BoxConstraints? constraints,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSection(
            title: '1. Service 调用 (Service Core)',
            content: Column(
              children: [
                Obx(() => Text('当前用户状态: ${controller.userStatus.value}')),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: controller.toggleLogin,
                  child: const Text('切换登录状态 (调用 AuthService)'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: controller.toggleTheme,
                  child: const Text('切换主题 (调用 ThemeService)'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: '2. 事件总线 (EventBus)',
            content: Column(
              children: [
                ElevatedButton(
                  onPressed: controller.sendEvent,
                  child: const Text('发送测试事件'),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Obx(
                    () => SingleChildScrollView(
                      child: Text(
                        controller.eventLog.value.isEmpty
                            ? '等待事件...'
                            : controller.eventLog.value,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildSection(
            title: '3. 路由跳转 (Router)',
            content: ElevatedButton(
              onPressed: controller.goToHome,
              child: const Text('跳转到首页模块 (RouterPath.home)'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget content}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }
}
