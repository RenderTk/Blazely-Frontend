import 'package:blazely/models/task.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

String updateAndDeleteUrl = "api/tasks/<taskId>/";
const createUrl = "api/tasks/";

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

  Future deleteTask(Dio dio, Task task) async {
    if (task.id == null) return;
    return;
  }

  Future createTask(Dio dio, Task task) async {
    return;
  }
}
