/// 用户服务接口
/// 定义了跨模块访问用户状态的能力
abstract class IUserService {
  bool get isLogin;
  String get userId;
  String get token;
  Future<void> login(String username, String password);
  Future<void> logout();
  Future<void> updateProfile(Map<String, dynamic> data);
}
