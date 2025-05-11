import 'package:blazely/models/group_list.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

const userGroupsListsUrl = '/api/groups/';

class GroupListService {
  final logger = Logger();

  Future<List<GroupList>> getLoggedInUserGroups(Dio dio) async {
    try {
      final response = await dio.get(userGroupsListsUrl);

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data
            .map((e) => GroupList.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception("An error occurred when fetching your groups.");
    } catch (e, stackTrace) {
      logger.e(
        "Failed to fetch logged-in user groups",
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
