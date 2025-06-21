import 'dart:async';
import 'dart:convert';
import 'package:blazely/models/token.dart';
import 'package:blazely/providers/auth_providers/token_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

const googleWebClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');
const baseApiUrl = String.fromEnvironment('BASE_API_URL');
const apiGoogleTokenVerifyUrl = '/auth/google/validate-token/';

class GoogleAuthNotifier extends Notifier {
  final logger = Logger();
  @override
  void build() {}

  Future<bool> googleSignIn() async {
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
    final tokenNotifier = ref.read(tokenAsyncProvider.notifier);
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        clientId: googleWebClientId,
      );

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final response = await dio.post<Map<String, dynamic>>(
        apiGoogleTokenVerifyUrl,
        data: jsonEncode({'id_token': googleAuth.idToken}),
      );
      logger.i('signing in...${googleUser.email}');

      final token = Token.fromJson(response.data!);
      await tokenNotifier.setToken(token);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> googleSignOut() async {
    final tokenNotifier = ref.read(tokenAsyncProvider.notifier);

    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      clientId: googleWebClientId,
    );
    await googleSignIn.signOut();
    logger.i('signing out...');

    //clear local secure storage and set isLoggedIn to false
    await tokenNotifier.clearToken();

    //blacklist refresh token (optional. it doesn't matter if it fails. A.K.A fire and forget)
    unawaited(
      tokenNotifier.blacklistToken().catchError((e) {
        return false;
      }),
    );
  }
}

final googleAuthProvider = NotifierProvider<GoogleAuthNotifier, void>(
  () => GoogleAuthNotifier(),
);
