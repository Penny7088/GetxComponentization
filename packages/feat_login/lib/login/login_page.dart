import 'package:flutter/material.dart';
import 'package:lib_base/getx/view/common_base_view.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:feat_login/login/login_controller.dart';

class LoginPage extends CommonBaseView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget createContentBody({
    required BuildContext context,
    BoxConstraints? constraints,
  }) {
    return Center(
      child: AppText.heading('Login Page'),
    );
  }
}
