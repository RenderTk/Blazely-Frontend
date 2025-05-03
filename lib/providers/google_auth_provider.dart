import 'dart:async';
import 'dart:convert';
import 'package:blazely/models/token.dart';
import 'package:blazely/providers/dio_provider.dart';
import 'package:blazely/providers/logged_in_provider.dart';
import 'package:blazely/providers/token_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

const googleWebClientId =
    '146630967901-aapesd267asicntrrcqndcd6npnlre4u.apps.googleusercontent.com';
const apiGoogleTokenVerifyUrl = '/auth/google/validate-token/';

class GoogleAuthProviderNotifier extends Notifier {
  @override
  void build() {}

  Future<bool> googleSignInn() async {
    final dio = ref.read(dioProvider);
    final isLoggedInNotifier = ref.read(isLoggedInProvider.notifier);
    final tokenNotifier = ref.read(tokenProviderNotifier.notifier);

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

      final token = Token.fromJson(response.data!);

      tokenNotifier.setToken(token);
      isLoggedInNotifier.setIsLoggedIn(true);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> googleSignOut() async {
    final isLoggedInNotifier = ref.read(isLoggedInProvider.notifier);
    final tokenNotifier = ref.read(tokenProviderNotifier.notifier);

    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      clientId: googleWebClientId,
    );
    await googleSignIn.signOut();

    // Set is logged in to false to prompt Google sign in
    isLoggedInNotifier.setIsLoggedIn(false);

    //blacklist refresh token (optional. it doesn't matter if it fails)
    unawaited(
      tokenNotifier.blacklistToken().catchError((e) {
        return false;
      }),
    );
  }
}

final googleAuthProvider = NotifierProvider<GoogleAuthProviderNotifier, void>(
  () => GoogleAuthProviderNotifier(),
);
