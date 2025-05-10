import 'package:blazely/models/task_list.dart';
import 'package:blazely/services/task_list_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class TaskListAsyncNotifier extends AsyncNotifier<List<TaskList>> {
  final logger = Logger();
  final _taskListService = TaskListService();

  @override
  Future<List<TaskList>> build() async {
    try {
      final groups = await _taskListService.getLoggedInUserTaskLists(ref);
      return groups;
    } catch (e, stackTrace) {
      logger.e(
        "Failed to fetch logged-in user task lists",
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }
}

final taskListAsyncProvider =
    AsyncNotifierProvider<TaskListAsyncNotifier, List<TaskList>>(
      () => TaskListAsyncNotifier(),
    );
