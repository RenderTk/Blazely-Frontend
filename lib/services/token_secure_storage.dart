import 'package:blazely/models/token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenSecureStorage {
  static final _storage = const FlutterSecureStorage();
  static const accessTokenKey = 'access_token';
  static const refreshTokenKey = 'refresh_token';

  static Future<void> setToken(Token token) async {
    if (token.accessToken == null || token.refreshToken == null) return;

    await _storage.write(key: accessTokenKey, value: token.accessToken);
    await _storage.write(key: refreshTokenKey, value: token.refreshToken);
  }

  static Future<void> clearToken() async {
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: refreshTokenKey);
  }

  static Future<Token?> getToken() async {
    final accessToken = await _storage.read(key: accessTokenKey);
    final refreshToken = await _storage.read(key: refreshTokenKey);
    if (accessToken == null || refreshToken == null) return null;
    return Token(accessToken: accessToken, refreshToken: refreshToken);
  }
}
