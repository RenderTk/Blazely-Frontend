import 'package:blazely/models/group_list.dart';
import 'package:blazely/models/task.dart';
import 'package:blazely/models/task_list.dart';
import 'package:blazely/providers/dio_provider.dart';
import 'package:blazely/providers/task_list_provider.dart';
import 'package:blazely/services/group_list_service.dart';
import 'package:blazely/services/task_list_service.dart';
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
  final taskListService = TaskListService();
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

  Future<GroupList?> addGroupList(String name) async {
    var groupListState = [...state.value!];

    if (name.isEmpty) return null;

    GroupList? createdGroupList;
    state = await AsyncValue.guard(() async {
      createdGroupList = await _groupListService.createGroup(dio, name);

      if (createdGroupList == null) {
        throw Exception("Failed to create group list.");
      }
      groupListState.add(createdGroupList!);
      return groupListState;
    });

    return createdGroupList;
  }

  Future<void> deleteGroupList(GroupList groupList) async {
    var groupListState = [...state.value!];
    if (groupListState.isEmpty) return;

    if (groupList.id == null || groupList.id! <= 0) return;

    state = await AsyncValue.guard(() async {
      // Update state on server
      await _groupListService.deleteGroup(dio, groupList);

      // Update state locally
      groupListState.removeWhere((gl) => gl.id == groupList.id);
      return groupListState;
    });
  }

  Future<void> updateGroupList(GroupList groupList) async {
    var groupListState = [...state.value!];

    if (groupListState.isEmpty) return;

    if (groupList.id == null || groupList.id! <= 0) return;

    state = await AsyncValue.guard(() async {
      // Update state on server
      await _groupListService.updateGroup(dio, groupList);

      // Update state locally
      groupListState[groupListState.indexWhere((gl) => gl.id == groupList.id)] =
          groupList;
      return groupListState;
    });
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

  Future<void> unGroupTaskList(
    GroupList groupList,
    List<TaskList> taskLists,
  ) async {
    var groupListState = [...state.value!];
    if (groupListState.isEmpty) return;

    if (groupList.id == null || groupList.id! <= 0) return;

    if (groupList.lists == null || groupList.lists!.isEmpty) return;

    final groupExists =
        groupListState.where((gl) => gl.id == groupList.id).firstOrNull != null;

    if (groupExists == false) return;

    state = await AsyncValue.guard(() async {
      // remove the group from the tasks lists
      await _groupListService.unGroupLists(dio, groupList, taskLists);

      //trigger rebuild on tasks list provider
      ref.invalidate(taskListAsyncProvider);

      final updatedTaskLists =
          groupList.lists?.where((li) => !taskLists.contains(li)).toList() ??
          [];
      // Update state locally => remove lists from group
      groupListState[groupListState.indexWhere(
        (gl) => gl.id == groupList.id,
      )] = groupList.copyWith(lists: updatedTaskLists);
      return groupListState;
    });
  }

  Future<void> groupTaskLists(
    GroupList groupList,
    List<TaskList> taskLists,
  ) async {
    var groupListState = [...state.value!];
    if (groupList.id == null || groupList.id! <= 0) return;

    final groupExists =
        groupListState.where((gl) => gl.id == groupList.id).firstOrNull != null;

    if (groupExists == false) return;

    state = await AsyncValue.guard(() async {
      // remove the group from the tasks lists
      await _groupListService.groupLists(dio, groupList, taskLists);

      //trigger rebuild on tasks list provider
      ref.invalidate(taskListAsyncProvider);

      final updatedTaskLists = [...groupList.lists!, ...taskLists];
      // Update state locally => remove lists from group
      groupListState[groupListState.indexWhere(
        (gl) => gl.id == groupList.id,
      )] = groupList.copyWith(lists: updatedTaskLists);
      return groupListState;
    });
  }

  Future<void> updateTaskListInGroup(TaskList taskList) async {
    var groupListState = [...state.value!];

    if (groupListState.isEmpty) return;

    if (taskList.id == null || taskList.id! <= 0 || taskList.group == null) {
      return;
    }

    state = await AsyncValue.guard(() async {
      // Find the group that contains this task list
      final groupIndex = groupListState.indexWhere(
        (group) => group.id == taskList.group,
      );

      if (groupIndex == -1) {
        // Group not found, return current state
        return groupListState;
      }

      // Get the current group
      final currentGroup = groupListState[groupIndex];

      // Update the task list within the group's lists
      final updatedLists =
          currentGroup.lists
              ?.map((tl) => tl.id == taskList.id ? taskList : tl)
              .toList() ??
          [];

      // Update state on server
      await taskListService.updateTaskList(dio, taskList);

      //TODO: refactor using freezed
      // Create updated group with new lists
      final updatedGroup = currentGroup.copyWith(lists: updatedLists);
      updatedGroup.lists = updatedLists;

      // Create new state with updated group
      final updatedGroupListState = List<GroupList>.from(groupListState);
      updatedGroupListState[groupIndex] = updatedGroup;

      return updatedGroupListState;
    });
  }

  Future<void> deleteTasklistInGroup(TaskList taskList) async {
    var groupListState = [...state.value!];

    if (groupListState.isEmpty) return;

    if (taskList.id == null || taskList.id! <= 0 || taskList.group == null) {
      return;
    }

    state = await AsyncValue.guard(() async {
      // Find the group that contains this task list
      final groupIndex = groupListState.indexWhere(
        (group) => group.id == taskList.group,
      );

      if (groupIndex == -1) {
        // Group not found, return current state
        return groupListState;
      }

      // Get the current group
      final currentGroup = groupListState[groupIndex];

      // Update the task list within the group's lists
      final updatedLists =
          currentGroup.lists?.where((tl) => tl.id != taskList.id).toList() ??
          [];

      // Update state on server
      await taskListService.deleteTaskList(dio, taskList);

      //TODO: refactor using freezed
      final updatedGroup = currentGroup.copyWith(lists: updatedLists);
      updatedGroup.lists = updatedLists;

      // Create new state with updated group
      final updatedGroupListState = List<GroupList>.from(groupListState);
      updatedGroupListState[groupIndex] = updatedGroup;

      return updatedGroupListState;
    });
  }
}

final groupListAsyncProvider =
    AsyncNotifierProvider<GroupListAsyncNotifier, List<GroupList>>(
      () => GroupListAsyncNotifier(),
    );
