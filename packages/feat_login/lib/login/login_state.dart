import 'package:lib_base/getx/state/base_state.dart';

class LoginState extends BaseState {
  LoginState() {
    // Initialize state properties here
    isNeedScaffold = true;
    isShowAppBar = true;
    appBarTitle = "Login";
  }

  @override
  void release() {
    // Clean up resources
  }
}
