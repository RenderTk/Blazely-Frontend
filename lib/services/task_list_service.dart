import 'package:blazely/models/task_list.dart';
import 'package:blazely/providers/dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

const userTaskListsUrl = "/api/lists/";

class TaskListService {
  final logger = Logger();

  Future<List<TaskList>> getLoggedInUserTaskLists(Ref ref) async {
    final dio = ref.read(dioProvider);
    try {
      final response = await dio.get(userTaskListsUrl);

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data
            .map((e) => TaskList.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception("An error occurred when fetching your task lists.");
    } catch (e, stackTrace) {
      logger.e(
        "Failed to fetch logged-in user task lists",
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
