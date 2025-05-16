import 'dart:async';
import 'package:blazely/models/token.dart';
import 'package:blazely/providers/logged_in_provider.dart';
import 'package:blazely/services/token_secure_storage_service.dart';
import 'package:blazely/services/token_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final String verifyTokenUrl = "auth/jwt/verify/";
final String refreshTokenUrl = "auth/jwt/refresh/";
final String blacklistTokenUrl = "auth/jwt/blacklist/";
const baseApiUrl = String.fromEnvironment('BASE_API_URL');

class TokenAsyncNotifier extends AsyncNotifier<Token?> {
  final _tokenService = TokenService();

  @override
  Future<Token?> build() => loadTokenFromLocalSecureStorage();

  Future<Token?> loadTokenFromLocalSecureStorage() async {
    final isLoggedInNotifier = ref.read(isLoggedInProvider.notifier);
    final localToken = await TokenSecureStorageService.getToken();

    //try to refresh the token
    if (localToken?.isExpired ?? true) {
      try {
        final refreshedToken = await _tokenService.refreshToken(localToken);

        // token was refreshed successfully, so user can be logged in
        isLoggedInNotifier.setIsLoggedIn(true);
        return refreshedToken;
      } catch (e) {
        // token was not refreshed successfully, so user can't be logged in
        isLoggedInNotifier.setIsLoggedIn(false);
        return null;
      }
    }

    // token was not expired, so user can be logged in
    isLoggedInNotifier.setIsLoggedIn(true);
    return localToken;
  }

  Future refreshToken() async {
    // Early return if no tokens available
    if (state.value == null) {
      return null;
    }
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _tokenService.refreshToken(state.value),
    );
  }

  Future setToken(Token token) async {
    if (token.accessToken == null || token.refreshToken == null) return;

    state = AsyncValue.data(token);
    final isLoggedInNotifier = ref.read(isLoggedInProvider.notifier);
    //save a copy on local secure storage
    await TokenSecureStorageService.setToken(token);

    //user is logged in
    isLoggedInNotifier.setIsLoggedIn(true);
  }

  Future clearToken() async {
    final isLoggedInNotifier = ref.read(isLoggedInProvider.notifier);
    isLoggedInNotifier.setIsLoggedIn(false);

    // Wait a short moment to ensure rebuild occurs and LogInSreen is rendered
    await Future.delayed(const Duration(milliseconds: 300));

    state = AsyncValue.data(null);
    await TokenSecureStorageService.clearToken();
  }

  Future blacklistToken() async {
    if (state.value == null) return;
    await _tokenService.blacklistToken(state.value);
  }
}

final tokenAsyncProvider = AsyncNotifierProvider<TokenAsyncNotifier, Token?>(
  () => TokenAsyncNotifier(),
);
