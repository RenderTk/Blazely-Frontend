import 'package:blazely/models/profile.dart';
import 'package:blazely/services/profile_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

const apiProfileUrl = '/api/profiles/me/';

class ProfileAsyncNotifier extends AsyncNotifier<Profile?> {
  final logger = Logger();
  final _profileService = ProfileService();

  @override
  Future<Profile?> build() async {
    try {
      final profile = await _profileService.getLoggedInUserProfile(ref);
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

  Future<void> loadProfile() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => _profileService.getLoggedInUserProfile(ref),
    );
  }
}

final profileAsyncProvider =
    AsyncNotifierProvider<ProfileAsyncNotifier, Profile?>(
      ProfileAsyncNotifier.new,
    );
