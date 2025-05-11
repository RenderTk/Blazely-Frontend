import 'package:blazely/models/profile.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

const apiProfileUrl = '/api/profiles/me/';

class ProfileService {
  final logger = Logger();

  Future<Profile?> getLoggedInUserProfile(Dio dio) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(apiProfileUrl);
      if (response.statusCode == 200) {
        return Profile.fromJson(response.data!);
      }
      throw Exception("An error occurred when fetching your profile.");
    } catch (e, stackTrace) {
      logger.e(
        "Failed to fetch logged-in user profile",
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
