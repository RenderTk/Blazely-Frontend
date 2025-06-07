import 'package:blazely/models/task.dart';
import 'package:blazely/utils/date_time_parsers.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

const updateAndDeleteUrl = "api/tasks/<taskId>/";
const createInListUrl = "api/lists/<listId>/tasks/";
const createInGroupUrl = "api/groups/<groupId>/lists/<listId>/tasks/";

enum TaskCreationContext { list, group }

class TaskService {
  final logger = Logger();

  Future updateTask(Dio dio, Task task) async {
    if (task.id == null) return;
    try {
      final response = await dio.put(
        updateAndDeleteUrl.replaceAll("<taskId>", "${task.id}"),
        data: task.toJson(),
        options: Options(
          headers: {
            ...dio.options.headers, // preserve default headers
          },
          sendTimeout: const Duration(seconds: 2),
          receiveTimeout: const Duration(seconds: 2),
        ),
      );

      if (response.statusCode != 200) {
        throw Exception("An error occurred when updating task.");
      }
    } catch (e, stackTrace) {
      logger.e("Failed to update task", error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<Task> createTask(
    Dio dio,
    String text,
    DateTime? dueDate,
    DateTime? reminderDate,
    bool isImportant,
    int? tasklistId,
    int? grouplistId,
    TaskCreationContext context,
  ) async {
    String url = "";
    if (context == TaskCreationContext.list) {
      //
      if (tasklistId == null) {
        throw Exception("Cannot create task in list if listId is null.");
      }
      url = createInListUrl.replaceAll("<listId>", "$tasklistId");
    } else if (context == TaskCreationContext.group) {
      //
      if (tasklistId == null || grouplistId == null) {
        throw Exception(
          "Cannot create task in group if listId or groupId is null.",
        );
      }

      url = createInGroupUrl
          .replaceAll("<groupId>", "$grouplistId")
          .replaceAll("<listId>", "$tasklistId");
    }

    final response = await dio.post(
      url,
      data: {
        "text": text,
        "due_date": dueDate != null ? dateFormatForApi.format(dueDate) : null,
        "reminder_date":
            reminderDate != null
                ? dateTimeFormatForApi.format(reminderDate)
                : null,
        "is_important": isImportant,
      },
    );
    // success code for post is 201
    if (response.statusCode != 201) {
      throw Exception("An error occurred when creating task.");
    }
    final createdTask = Task.fromJson(response.data);
    return createdTask;
  }

  Future deleteTask(Dio dio, Task task) async {
    if (task.id == null) return;
    return;
  }
}
