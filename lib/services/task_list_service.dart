import 'package:blazely/models/task_list.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

const userTaskListsUrl = "/api/lists/";

class TaskListService {
  final logger = Logger();

  Future<List<TaskList>> getLoggedInUserTaskLists(Dio dio) async {
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
