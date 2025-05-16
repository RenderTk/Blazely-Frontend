import 'package:blazely/models/group_list.dart';
import 'package:blazely/models/task.dart';
import 'package:blazely/providers/dio_provider.dart';
import 'package:blazely/services/group_list_service.dart';
import 'package:blazely/services/task_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class _AffectedIndexes {
  final int groupIndex;
  final int taskListIndex;
  final int taskIndex;

  _AffectedIndexes({
    required this.groupIndex,
    required this.taskListIndex,
    required this.taskIndex,
  });
}

class GroupListAsyncNotifier extends AsyncNotifier<List<GroupList>> {
  final logger = Logger();
  final _groupListService = GroupListService();
  final _taskService = TaskService();
  late Dio dio;

  @override
  Future<List<GroupList>> build() async {
    try {
      dio = ref.watch(dioProvider);
      final groups = await _groupListService.getLoggedInUserGroups(dio);
      return groups;
    } catch (e, stackTrace) {
      logger.e(
        "Failed to fetch logged-in user group lists",
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  Future<void> toggleIsCompletedOnTask(
    int groupId,
    int taskListId,
    int taskId,
    bool isCompleted,
  ) async {
    final affectedIndexes = _getAffectedIndexes(groupId, taskListId, taskId);
    if (affectedIndexes == null) return;

    var taskToUpdate = _getTaskToUpdate(affectedIndexes);
    if (taskToUpdate == null) return;

    taskToUpdate = taskToUpdate.copyWith(isCompleted: isCompleted);

    await _updateTask(affectedIndexes, taskToUpdate);
  }

  Future<void> toggleIsImportantOnTask(
    int groupId,
    int taskListId,
    int taskId,
    bool isImportant,
  ) async {
    final affectedIndexes = _getAffectedIndexes(groupId, taskListId, taskId);
    if (affectedIndexes == null) return;

    var taskToUpdate = _getTaskToUpdate(affectedIndexes);
    if (taskToUpdate == null) return;

    taskToUpdate = taskToUpdate.copyWith(isImportant: isImportant);

    await _updateTask(affectedIndexes, taskToUpdate);
  }

  Future<void> _updateTask(
    _AffectedIndexes affectedIndexes,
    Task updatedTask,
  ) async {
    if (state.value?.isEmpty ?? true) return;

    state = await AsyncValue.guard(() async {
      var groupListState = [...state.value!];

      final group = groupListState.elementAtOrNull(affectedIndexes.groupIndex);
      final taskList = group?.lists?.elementAtOrNull(
        affectedIndexes.taskListIndex,
      );
      final task = taskList?.tasks?.elementAtOrNull(affectedIndexes.taskIndex);

      if (group == null || taskList == null || task == null) {
        throw Exception(
          "Invalid index while updating task of the task list in the group.",
        );
      }

      // Update state on server
      await _taskService.updateTask(dio, updatedTask);

      // Update state locally
      groupListState[affectedIndexes.groupIndex]
              .lists?[affectedIndexes.taskListIndex]
              .tasks?[affectedIndexes.taskIndex] =
          updatedTask;

      return groupListState;
    });
  }

  Task? _getTaskToUpdate(_AffectedIndexes affectedIndexes) {
    var updatedGroups = [...state.value ?? []];
    if (updatedGroups.isEmpty) return null;

    var taskToUpdate =
        updatedGroups[affectedIndexes.groupIndex]
            .lists?[affectedIndexes.taskListIndex]
            .tasks?[affectedIndexes.taskIndex];

    return taskToUpdate;
  }

  _AffectedIndexes? _getAffectedIndexes(
    int groupId,
    int taskListId,
    int taskId,
  ) {
    if (state.value?.isEmpty ?? true) return null;
    var groupListsState = [...state.value!];

    var affectedGroupIndex = groupListsState.indexWhere(
      (gl) => gl.id == groupId,
    );

    var affectedTaskListIndex =
        groupListsState[affectedGroupIndex].lists?.indexWhere(
          (li) => li.id == taskListId,
        ) ??
        -1;

    var affectedTaskIndex =
        groupListsState[affectedGroupIndex].lists?[affectedTaskListIndex].tasks
            ?.indexWhere((t) => t.id == taskId) ??
        -1;

    if (affectedGroupIndex == -1 ||
        affectedTaskListIndex == -1 ||
        affectedTaskIndex == -1) {
      return null;
    }

    return _AffectedIndexes(
      groupIndex: affectedGroupIndex,
      taskListIndex: affectedTaskListIndex,
      taskIndex: affectedTaskIndex,
    );
  }
}

final groupListAsyncProvider =
    AsyncNotifierProvider<GroupListAsyncNotifier, List<GroupList>>(
      () => GroupListAsyncNotifier(),
    );
