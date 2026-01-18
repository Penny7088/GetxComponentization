import 'package:get/get.dart';
import 'package:service_router/service_router.dart';

class AuthService extends GetxService implements IUserService {
  final RxBool _isLogin = false.obs;
  final RxString _userId = ''.obs;
  final RxString _token = ''.obs;

  @override
  bool get isLogin => _isLogin.value;

  @override
  String get userId => _userId.value;

  @override
  String get token => _token.value;

  @override
  Future<void> login(String username, String password) async {
    // TODO: Implement actual login logic with API
    await Future.delayed(const Duration(seconds: 1));
    _isLogin.value = true;
    _userId.value = 'user_123';
    _token.value = 'dummy_token';
  }

  @override
  Future<void> logout() async {
    // TODO: Implement logout logic
    _isLogin.value = false;
    _userId.value = '';
    _token.value = '';
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> data) async {
    // TODO: Implement update profile logic
  }
}
