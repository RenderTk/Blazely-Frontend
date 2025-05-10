import 'package:blazely/models/profile.dart';
import 'package:blazely/providers/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const apiProfileUrl = '/api/profiles/me/';

final profileProvider = FutureProvider<Profile>((ref) async {
  final dio = ref.read(dioProvider);
  try {
    final response = await dio.get<Map<String, dynamic>>(apiProfileUrl);
    if (response.statusCode == 200) {
      return Profile.fromJson(response.data!);
    }
    throw Exception("An error occurred when fetching profile.");
  } catch (e) {
    rethrow;
  }
});
