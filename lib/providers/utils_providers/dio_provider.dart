import 'package:blazely/models/token.dart';
import 'package:blazely/providers/auth_providers/google_auth_provider.dart';
import 'package:blazely/providers/auth_providers/token_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

const baseApiUrl = String.fromEnvironment('BASE_API_URL');

class DioNotifier extends Notifier<Dio> {
  final logger = Logger();
  late AsyncValue<Token?> tokenState;
  late TokenAsyncNotifier tokenNotifier;
  late GoogleAuthNotifier googleAuthNotifier;

  @override
  Dio build() {
    tokenState = ref.watch(tokenAsyncProvider);
    tokenNotifier = ref.watch(tokenAsyncProvider.notifier);
    googleAuthNotifier = ref.watch(googleAuthProvider.notifier);

    logger.i('Dio built');
    return _getConfiguredDio();
  }

  Dio _getConfiguredDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseApiUrl,
        connectTimeout: const Duration(seconds: 4),
        receiveTimeout: const Duration(seconds: 4),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          //if access token is expired, try to refresh
          if (tokenState.value?.isExpired ?? true) {
            await tokenNotifier.refreshToken();
          }

          options.headers['Authorization'] =
              'Bearer ${tokenState.value?.accessToken}';
          return handler.next(options);
        },

        onError: (DioException error, handler) async {
          final requestOptions = error.requestOptions;

          // Case 1: Authentication error (401)
          if (error.response?.statusCode == 401) {
            try {
              // Refresh token
              await tokenNotifier.refreshToken();

              // Retry the request with updated token and retry count
              final opts = Options(
                method: requestOptions.method,
                headers: {
                  'Authorization': 'Bearer ${tokenState.value?.accessToken}',
                  ...requestOptions.headers,
                },
              );

              final response = await dio.request(
                requestOptions.path,
                data: requestOptions.data,
                queryParameters: requestOptions.queryParameters,
                options: opts,
              );

              return handler.resolve(response);
            } catch (e) {
              await googleAuthNotifier.googleSignOut();
              return handler.reject(error);
            }
          }
          // Case 2: Connection error (offline server)
          else if ((error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError)) {
            //
            return handler.reject(error);
          }

          // For all other errors or when retry limits are reached, continue with the error
          return handler.reject(error);
        },
      ),
    );
    return dio;
  }

  void rebuildDio() {
    state = _getConfiguredDio();
  }
}

final dioProvider = NotifierProvider<DioNotifier, Dio>(DioNotifier.new);
