import 'package:blazely/providers/google_auth_provider.dart';
import 'package:blazely/providers/token_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const baseApiUrl = String.fromEnvironment('BASE_API_URL');

final dioProvider = Provider<Dio>((ref) {
  final tokenProvider = ref.read(tokenProviderNotifier);
  final tokenNotifier = ref.read(tokenProviderNotifier.notifier);
  final googleAuthNotifier = ref.read(googleAuthProvider.notifier);

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

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        //if access token is expired, try to refresh
        if (tokenProvider.isExpired) {
          await tokenNotifier.refreshToken();
        }

        options.headers['Authorization'] =
            'Bearer ${tokenProvider.accessToken}';

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
                'Authorization': 'Bearer ${tokenProvider.accessToken}',
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
          await googleAuthNotifier.googleSignOut();
          return handler.reject(error);
        }

        // For all other errors or when retry limits are reached, continue with the error
        return handler.next(error);
      },
    ),
  );

  return dio;
});
