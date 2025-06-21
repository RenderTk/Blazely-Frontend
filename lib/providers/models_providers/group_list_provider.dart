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

  //
  //--------------------------------------------------------- PRIVATE METHODS --------------------------------------------------------- //
  //

  List<GroupList> _createDeepCopyOfState() {
    final groupListState = [
      ...state.value!.map(
        (group) => group.copyWith(
          lists:
              group.lists
                  ?.map(
                    (taskList) => taskList.copyWith(
                      tasks:
                          taskList.tasks
                              ?.map((task) => task.copyWith())
                              .toList(),
                    ),
                  )
                  .toList(),
        ),
      ),
    ];
    return groupListState;
  }

  void _commonGroupListGuardChecks(
    GroupList groupList,
    List<GroupList> groupListState,
  ) {
    if (groupList.id <= 0) {
      throw Exception("Invalid group list id.");
    }

    final int affectedGroupIndex = groupListState.indexWhere(
      (gl) => gl.id == groupList.id,
    );
    if (affectedGroupIndex == -1) {
      throw Exception("Group list not found.");
    }
  }

  void _commonTaskListsGuardChecks(List<TaskList> taskLists) {
    if (taskLists.isEmpty) {
      throw Exception("Tasklist list is empty.");
    }
    if (taskLists.any((tl) => tl.id <= 0)) {
      throw Exception("One or more tasklists have an invalid id.");
    }
  }

  void _commonTaskListGuardChecks(
    TaskList taskList,
    List<GroupList> groupListState,
  ) {
    if (taskList.id <= 0) {
      throw Exception("Invalid task list ID.");
    }
    if (taskList.group == null || taskList.group! <= 0) {
      throw Exception("Task list is not assigned to any group.");
    }

    final affectedGroupIndex = groupListState.indexWhere(
      (group) => group.id == taskList.group,
    );

    if (affectedGroupIndex == -1) {
      throw Exception("No group list found containing the provided task list.");
    }
  }

  void _commonTaskGuardChecks(
    Task task,
    int groupListIndex,
    int taskListIndex,
    List<GroupList> groupListState,
  ) {
    if (task.id <= 0) {
      throw Exception("Invalid task ID.");
    }

    final affectedTaskIndex = groupListState[groupListIndex].lists!
        .elementAt(taskListIndex)
        .tasks!
        .indexWhere((t) => t.id == task.id);

    if (affectedTaskIndex == -1) {
      throw Exception(
        "Task not found in the given tasklist in the given group.",
      );
    }
  }

  //
  //--------------------------------------------------------- GROUPLIST CRUD METHODS --------------------------------------------------------- //
  //

  Future<GroupList?> addGroupList(String name) async {
    var groupListState = _createDeepCopyOfState();

    GroupList? createdGroupList;
    state = await AsyncValue.guard(() async {
      if (name.isEmpty) {
        throw Exception("Group name cannot be empty.");
      }
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
    var groupListState = _createDeepCopyOfState();

    state = await AsyncValue.guard(() async {
      _commonGroupListGuardChecks(groupList, groupListState);

      // Update state on server
      await _groupListService.deleteGroup(dio, groupList);

      // Update state locally
      groupListState.removeWhere((gl) => gl.id == groupList.id);
      return groupListState;
    });
  }

  Future<void> updateGroupList(GroupList groupList) async {
    var groupListState = _createDeepCopyOfState();

    state = await AsyncValue.guard(() async {
      _commonGroupListGuardChecks(groupList, groupListState);

      // Update state on server
      await _groupListService.updateGroup(dio, groupList);

      // Update state locally
      groupListState[groupListState.indexWhere((gl) => gl.id == groupList.id)] =
          groupList;
      return groupListState;
    });
  }

  //
  //--------------------------------------------------------- TASKLIST CRUD METHODS --------------------------------------------------------- //
  //

  Future<void> unGroupTaskList(
    GroupList groupList,
    List<TaskList> taskLists,
  ) async {
    var groupListState = _createDeepCopyOfState();

    state = await AsyncValue.guard(() async {
      _commonGroupListGuardChecks(groupList, groupListState);
      _commonTaskListsGuardChecks(taskLists);

      final int affectedGroupIndex = groupListState.indexWhere(
        (gl) => gl.id == groupList.id,
      );

      // remove the group from the tasks lists
      await _groupListService.unGroupLists(dio, groupList, taskLists);

      //trigger rebuild on tasks list provider
      ref.invalidate(taskListAsyncProvider);

      final updatedTaskListsInGroup =
          groupList.lists
              ?.where(
                (li) => !taskLists.any((taskList) => taskList.id == li.id),
              )
              .toList() ??
          [];

      // Update state locally => remove lists from group
      groupListState[affectedGroupIndex].lists = updatedTaskListsInGroup;

      return groupListState;
    });
  }

  Future<void> groupTaskLists(
    GroupList groupList,
    List<TaskList> taskLists,
  ) async {
    var groupListState = _createDeepCopyOfState();

    state = await AsyncValue.guard(() async {
      _commonGroupListGuardChecks(groupList, groupListState);
      _commonTaskListsGuardChecks(taskLists);

      final int affectedGroupIndex = groupListState.indexWhere(
        (gl) => gl.id == groupList.id,
      );
      // remove the group from the tasks lists
      await _groupListService.groupLists(dio, groupList, taskLists);

      //trigger rebuild on tasks list provider
      ref.invalidate(taskListAsyncProvider);

      final currentLists = groupListState[affectedGroupIndex].lists ?? [];
      final updatedTaskListsInGroup = [...currentLists, ...taskLists];

      groupListState[affectedGroupIndex].lists = updatedTaskListsInGroup;

      return groupListState;
    });
  }

  Future<void> updateTaskListInGroup(TaskList taskList) async {
    var groupListState = _createDeepCopyOfState();

    state = await AsyncValue.guard(() async {
      _commonTaskListGuardChecks(taskList, groupListState);

      // Find the group that contains this task list
      final groupListIndex = groupListState.indexWhere(
        (group) => group.id == taskList.group,
      );

      final taskListIndex = groupListState[groupListIndex].lists?.indexWhere(
        (tl) => tl.id == taskList.id,
      );

      // Update state on server
      await taskListService.updateTaskList(dio, taskList);

      //update state locally
      groupListState[groupListIndex].lists![taskListIndex!] = taskList;

      return groupListState;
    });
  }

  Future<void> deleteTasklistInGroup(TaskList taskList) async {
    var groupListState = _createDeepCopyOfState();

    state = await AsyncValue.guard(() async {
      _commonTaskListGuardChecks(taskList, groupListState);

      final affectedGroupIndex = groupListState.indexWhere(
        (group) => group.id == taskList.group,
      );

      final taskListIndex = groupListState[affectedGroupIndex].lists
          ?.indexWhere((tl) => tl.id == taskList.id);

      // Update on server
      await taskListService.deleteTaskList(dio, taskList);

      // Then update locally
      groupListState[affectedGroupIndex].lists!.removeAt(taskListIndex!);

      return groupListState;
    });
  }

  //
  //--------------------------------------------------------- TASK CRUD METHODS --------------------------------------------------------- //
  //

  Future<void> addTask(
    GroupList groupList,
    TaskList taskList,
    Task task,
  ) async {
    // Create a proper deep copy
    final groupListState = _createDeepCopyOfState();

    state = await AsyncValue.guard(() async {
      _commonGroupListGuardChecks(groupList, groupListState);
      _commonTaskListGuardChecks(taskList, groupListState);

      final affectedGroupIndex = groupListState.indexWhere(
        (gl) => gl.id == groupList.id,
      );
      final affectedTaskListIndex = groupListState[affectedGroupIndex].lists
          ?.indexWhere((li) => li.id == taskList.id);

      // Create the task on the server
      final createdTask = await _taskService.createTask(
        dio,
        task.text,
        task.dueDate,
        task.reminderDate,
        task.isImportant,
        taskList.id,
        groupList.id,
        TaskCreationContext.group,
      );

      // Add the task to the copied state
      groupListState[affectedGroupIndex].lists![affectedTaskListIndex!].tasks!
          .add(createdTask);

      return groupListState;
    });
  }

  Future<void> updateTask(
    GroupList groupList,
    TaskList taskList,
    Task task,
  ) async {
    // Create a proper deep copy
    final groupListState = _createDeepCopyOfState();

    state = await AsyncValue.guard(() async {
      _commonGroupListGuardChecks(groupList, groupListState);
      _commonTaskListGuardChecks(taskList, groupListState);

      final affectedGroupListIndex = groupListState.indexWhere(
        (gl) => gl.id == groupList.id,
      );

      final affectedTaskListIndex = groupListState[affectedGroupListIndex].lists
          ?.indexWhere((li) => li.id == taskList.id);

      _commonTaskGuardChecks(
        task,
        affectedGroupListIndex,
        affectedTaskListIndex!,
        groupListState,
      );
      final affectedTaskIndex = groupListState[affectedGroupListIndex].lists!
          .elementAt(affectedTaskListIndex)
          .tasks!
          .indexWhere((t) => t.id == task.id);

      // Update the task on the server
      await _taskService.updateTask(dio, task);

      groupListState[affectedGroupListIndex]
              .lists![affectedTaskListIndex]
              .tasks![affectedTaskIndex] =
          task;

      return groupListState;
    });
  }
}

//
//--------------------------------------------------------- PROVIDER CLASS --------------------------------------------------------- //
//

final groupListAsyncProvider =
    AsyncNotifierProvider<GroupListAsyncNotifier, List<GroupList>>(
      () => GroupListAsyncNotifier(),
    );
