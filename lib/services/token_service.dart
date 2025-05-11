import 'dart:convert';

import 'package:blazely/models/token.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

final String verifyTokenUrl = "auth/jwt/verify/";
final String refreshTokenUrl = "auth/jwt/refresh/";
final String blacklistTokenUrl = "auth/jwt/blacklist/";
const baseApiUrl = String.fromEnvironment('BASE_API_URL');

class TokenService {
  final logger = Logger();
  final dio = Dio(
    BaseOptions(
      baseUrl: baseApiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );
  Future<Token?> refreshToken(Token? token) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        refreshTokenUrl,
        data: jsonEncode({"refresh": token?.refreshToken}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final token = Token.fromJson(response.data!);
        return token;
      } else if (response.statusCode == 401) {
        throw Exception("Your session has expired. Please log in again.");
      } else if (response.statusCode == 403) {
        throw Exception("Access denied. You might need to log in again.");
      } else {
        throw Exception(
          "Unable to refresh your session. Please try again later.",
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw Exception(
          "Connection timed out. Please check your internet connection and try again.",
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          "No internet connection. Please check your network settings and try again.",
        );
      } else if (e.response?.statusCode == 429) {
        throw Exception(
          "Too many attempts. Please wait a moment before trying again.",
        );
      } else {
        throw Exception(
          "Network error occurred. Please check your connection and try again.",
        );
      }
    } catch (e) {
      throw Exception(
        "An unexpected error occurred. Please try logging in again.",
      );
    }
  }

  Future<bool> blacklistToken(Token? token) async {
    try {
      final response = await dio.post(
        blacklistTokenUrl,
        data: jsonEncode({"refresh": token?.refreshToken}),
      );

      if (response.statusCode != 200) {
        logger.w("Failed to blacklist token.");
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
