import 'package:blazely/models/task.dart';
import 'package:blazely/models/task_list.dart';
import 'package:blazely/providers/dio_provider.dart';
import 'package:blazely/services/task_list_service.dart';
import 'package:blazely/services/task_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class _AffectedIndexes {
  final int taskListIndex;
  final int taskIndex;

  _AffectedIndexes({required this.taskListIndex, required this.taskIndex});
}

class TaskListAsyncNotifier extends AsyncNotifier<List<TaskList>> {
  final logger = Logger();
  final _taskListService = TaskListService();
  final _taskService = TaskService();
  late Dio dio;

  @override
  Future<List<TaskList>> build() async {
    try {
      dio = ref.watch(dioProvider);
      final groups = await _taskListService.getLoggedInUserTaskLists(dio);
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

  Future<void> toggleIsImportantOnTask(
    int taskListId,
    int taskId,
    bool isImportant,
  ) async {
    final affectedIndexes = _getAffectedIndexes(taskListId, taskId);
    if (affectedIndexes == null) return;

    var taskToUpdate = _getTaskToUpdate(affectedIndexes);
    if (taskToUpdate == null) return;

    taskToUpdate = taskToUpdate.copyWith(isImportant: isImportant);

    await _updateTask(affectedIndexes, taskToUpdate);
  }

  Future<void> toggleIsCompletedOnTask(
    int taskListId,
    int taskId,
    bool isCompleted,
  ) async {
    final affectedIndexes = _getAffectedIndexes(taskListId, taskId);
    if (affectedIndexes == null) return;

    var taskToUpdate = _getTaskToUpdate(affectedIndexes);
    if (taskToUpdate == null) return;

    taskToUpdate = taskToUpdate.copyWith(isCompleted: isCompleted);

    await _updateTask(affectedIndexes, taskToUpdate);
  }

  Future<void> _updateTask(
    _AffectedIndexes affectedIndexes,
    Task updatedTask,
  ) async {
    if (state.value?.isEmpty ?? true) return;

    state = await AsyncValue.guard(() async {
      var taskListState = [...state.value!];

      final taskList = taskListState.elementAtOrNull(
        affectedIndexes.taskListIndex,
      );
      final task = taskList?.tasks?.elementAtOrNull(affectedIndexes.taskIndex);

      if (taskList == null || task == null) {
        throw Exception("Invalid index while updating task in the task list.");
      }

      // Update state on server
      await _taskService.updateTask(dio, task);

      // Update state locally
      taskListState[affectedIndexes.taskListIndex].tasks?[affectedIndexes
              .taskIndex] =
          updatedTask;

      return taskListState;
    });
  }

  Task? _getTaskToUpdate(_AffectedIndexes affectedIndexes) {
    var taskListState = [...state.value ?? []];
    if (taskListState.isEmpty) return null;

    var taskToUpdate =
        taskListState[affectedIndexes.taskListIndex].tasks?[affectedIndexes
            .taskIndex];

    return taskToUpdate;
  }

  _AffectedIndexes? _getAffectedIndexes(int taskListId, int taskId) {
    if (state.value?.isEmpty ?? true) return null;

    final affectedTaskListIndex =
        state.value?.indexWhere((tl) => tl.id == taskListId) ?? -1;
    if (affectedTaskListIndex == -1) return null;

    final affectedTaskIndex =
        state.value?[affectedTaskListIndex].tasks!.indexWhere(
          (t) => t.id == taskId,
        ) ??
        -1;
    if (affectedTaskIndex == -1) return null;

    return _AffectedIndexes(
      taskListIndex: affectedTaskListIndex,
      taskIndex: affectedTaskIndex,
    );
  }
}

final taskListAsyncProvider =
    AsyncNotifierProvider<TaskListAsyncNotifier, List<TaskList>>(
      () => TaskListAsyncNotifier(),
    );
