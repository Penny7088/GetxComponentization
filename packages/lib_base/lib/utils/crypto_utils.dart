import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

class CryptoUtils {
  // TODO: 请替换为后端提供的真实 Key 和 IV
  // AES key length must be 16, 24, or 32 bytes (128, 192, or 256 bits)
  static const String _keyStr = '1234567890123456'; 
  static const String _ivStr = '1234567890123456';

  static final _key = encrypt.Key.fromUtf8(_keyStr);
  static final _iv = encrypt.IV.fromUtf8(_ivStr);

  // 使用 AES-CBC 模式，PKCS7 Padding
  static final _encrypter = encrypt.Encrypter(
    encrypt.AES(_key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
  );

  /// 加密
  static String encryptData(dynamic data) {
    try {
      String plainText;
      if (data is String) {
        plainText = data;
      } else {
        plainText = jsonEncode(data);
      }
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      print('Encrypt Error: $e');
      return '';
    }
  }

  /// 解密
  static dynamic decryptData(String encryptedBase64) {
    try {
      final decrypted = _encrypter.decrypt64(encryptedBase64, iv: _iv);
      // 尝试解析为 JSON 对象，如果失败则返回字符串
      try {
        return jsonDecode(decrypted);
      } catch (_) {
        return decrypted;
      }
    } catch (e) {
      print('Decrypt Error: $e');
      return null;
    }
  }
}
