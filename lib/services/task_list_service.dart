import 'package:blazely/models/task_list.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

const usersTaskListsUrl = "/api/lists/?has_group=false";
const createTaskListUrl = "/api/lists/";
String updateAndDeleteUrl = "api/lists/<listId>/";

class TaskListService {
  final logger = Logger();

  Future<List<TaskList>> getLoggedInUserTaskListsWithoutGroup(Dio dio) async {
    try {
      final response = await dio.get(usersTaskListsUrl);

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data
            .map((e) => TaskList.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception("An error occurred when fetching your lists.");
    } catch (e, stackTrace) {
      logger.e(
        "Failed to fetch logged-in user lists",
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  Future<TaskList> createList(Dio dio, String name, String emoji) async {
    try {
      if (name.isEmpty || emoji.isEmpty) {
        throw Exception("Name and emoji cannot be empty.");
      }
      final response = await dio.post(
        createTaskListUrl,
        data: {"name": name, "emoji": emoji},
      );
      final createdTask = TaskList.fromJson(response.data);
      return createdTask;
    } catch (e, stackTrace) {
      logger.e("Failed to create the list.", error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future updateTaskList(Dio dio, TaskList taskList) async {
    if (taskList.id == null) return;
    try {
      final response = await dio.put(
        updateAndDeleteUrl.replaceAll("<listId>", "${taskList.id}"),
        data: taskList.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception("An error occurred when updating the list.");
      }
    } catch (e, stackTrace) {
      logger.e("Failed to update the list.", error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future deleteTaskList(Dio dio, TaskList taskList) async {
    if (taskList.id == null) return;
    try {
      final response = await dio.delete(
        updateAndDeleteUrl.replaceAll("<listId>", "${taskList.id}"),
      );

      //server retrurns 204 when successfully deleted
      if (response.statusCode != 204) {
        throw Exception("An error occurred when deleting the list.");
      }
    } catch (e, stackTrace) {
      logger.e("Failed to delete the list.", error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}
