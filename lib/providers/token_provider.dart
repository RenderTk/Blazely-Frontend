import 'dart:async';
import 'dart:convert';
import 'package:blazely/models/token.dart';
import 'package:blazely/providers/logged_in_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final String verifyTokenUrl = "auth/jwt/verify/";
final String refreshTokenUrl = "auth/jwt/refresh/";
final String blacklistTokenUrl = "auth/jwt/blacklist/";
const baseApiUrl = String.fromEnvironment('BASE_API_URL');

class TokenNotifier extends Notifier<Token> {
  @override
  Token build() {
    return Token(accessToken: null, refreshToken: null);
  }

  Future<bool> refreshToken() async {
    if (state.accessToken == null || state.refreshToken == null) return false;

    //raw dio instance to avoid circular dependency
    final dio = Dio(
      BaseOptions(
        baseUrl: baseApiUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    try {
      final response = await dio.post<Map<String, dynamic>>(
        refreshTokenUrl,
        data: jsonEncode({"refresh": state.refreshToken}),
      );

      if (response.statusCode == 200) {
        final token = Token.fromJson(response.data!);
        state = token;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void setToken(Token token) {
    if (token.accessToken == null || token.refreshToken == null) return;

    final isLoggedInNotifier = ref.read(isLoggedInProvider.notifier);
    isLoggedInNotifier.setIsLoggedIn(true);
    state = token;
  }

  Future<bool> verifyToken() async {
    if (state.accessToken == null) return false;

    final dio = Dio(
      BaseOptions(
        baseUrl: baseApiUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    try {
      final response = await dio.post(
        verifyTokenUrl,
        data: jsonEncode({"token": state.accessToken}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> blacklistToken() async {
    if (state.accessToken == null) return false;

    final dio = Dio(
      BaseOptions(
        baseUrl: baseApiUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {
          'Authorization': 'Bearer ${state.accessToken}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    try {
      final response = await dio.post(
        blacklistTokenUrl,
        data: jsonEncode({"refresh": state.refreshToken}),
      );
      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

final tokenProviderNotifier = NotifierProvider<TokenNotifier, Token>(
  () => TokenNotifier(),
);
