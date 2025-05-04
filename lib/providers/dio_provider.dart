import 'package:blazely/providers/google_auth_provider.dart';
import 'package:blazely/providers/token_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const baseApiUrl = String.fromEnvironment('BASE_API_URL');

final dioProvider = Provider<Dio>((ref) {
  final tokenProvider = ref.read(tokenProviderNotifier);
  final tokenNotifier = ref.read(tokenProviderNotifier.notifier);
  final googleAuthNotifier = ref.read(googleAuthProvider.notifier);

  print(baseApiUrl);
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

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (tokenProvider.accessToken != null &&
            tokenProvider.isExpired == false) {
          //
          options.headers['Authorization'] =
              'Bearer ${tokenProvider.accessToken}';
        }

        //
        return handler.next(options);
      },

      //
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          try {
            await tokenNotifier.refreshToken();

            // Update header
            dio.options.headers['Authorization'] =
                'Bearer ${tokenProvider.accessToken}';

            // Retry original request
            final opts = Options(
              method: error.requestOptions.method,
              headers: {'Authorization': 'Bearer ${tokenProvider.accessToken}'},
            );

            final cloneReq = await dio.request(
              error.requestOptions.path,
              options: opts,
              data: error.requestOptions.data,
              queryParameters: error.requestOptions.queryParameters,
            );

            return handler.resolve(cloneReq);
          } catch (e) {
            //
            await googleAuthNotifier.googleSignOut();
            return handler.reject(error);
          }
        }

        return handler.next(error);
      },
    ),
  );

  return dio;
});
