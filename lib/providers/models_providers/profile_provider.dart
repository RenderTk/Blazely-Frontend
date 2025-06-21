import 'package:blazely/models/profile.dart';
import 'package:blazely/providers/utils_providers/dio_provider.dart';
import 'package:blazely/services/profile_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

const apiProfileUrl = '/api/profiles/me/';

class ProfileAsyncNotifier extends AsyncNotifier<Profile?> {
  final logger = Logger();
  final _profileService = ProfileService();
  late Dio dio;

  @override
  Future<Profile?> build() async {
    try {
      dio = ref.watch(dioProvider);
      final profile = await _profileService.getLoggedInUserProfile(dio);
      return profile;
    } catch (e, stackTrace) {
      logger.e(
        "Failed to fetch logged-in user profile",
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  void clearProfile() => state = AsyncValue.data(null);

  Future<void> loadProfile() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async => await _profileService.getLoggedInUserProfile(dio),
    );
  }
}

final profileAsyncProvider =
    AsyncNotifierProvider<ProfileAsyncNotifier, Profile?>(
      ProfileAsyncNotifier.new,
    );
