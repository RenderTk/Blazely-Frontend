import 'package:blazely/models/task.dart';
import 'package:blazely/models/task_list.dart';
import 'package:blazely/providers/dio_provider.dart';
import 'package:blazely/services/task_list_service.dart';
import 'package:blazely/services/task_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class TaskListAsyncNotifier extends AsyncNotifier<List<TaskList>> {
  final logger = Logger();
  final _taskListService = TaskListService();
  final _taskService = TaskService();
  late Dio dio;

  @override
  Future<List<TaskList>> build() async {
    try {
      dio = ref.watch(dioProvider);
      final groups = await _taskListService
          .getLoggedInUserTaskListsWithoutGroup(dio);
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

  //
  //--------------------------------------------------------- PRIVATE METHODS --------------------------------------------------------- //
  //

  List<TaskList> _createDeepCopyOfState() {
    final taskListsState = [
      ...state.value!.map(
        (taskList) => taskList.copyWith(
          tasks: taskList.tasks?.map((task) => task.copyWith()).toList(),
        ),
      ),
    ];
    return taskListsState;
  }

  void _commonTaskListGuardChecks(
    TaskList taskList,
    List<TaskList> taskListsState,
  ) {
    if (taskList.id == null || taskList.id! <= 0) {
      throw Exception("The provided tasklist has an invalid id.");
    }
    final affectedTaskListIndex = taskListsState.indexWhere(
      (tl) => tl.id == taskList.id,
    );

    if (affectedTaskListIndex == -1) {
      throw Exception("Task list not found.");
    }
  }

  //
  //--------------------------------------------------------- TASKlIST CRUD METHODS --------------------------------------------------------- //
  //

  Future<TaskList?> addTaskList(String name, String emoji) async {
    var taskListsState = _createDeepCopyOfState();

    TaskList? createdTaskList;
    state = await AsyncValue.guard(() async {
      if (name.isEmpty || emoji.isEmpty) {
        throw Exception("Name and emoji cannot be empty.");
      }
      createdTaskList = await _taskListService.createList(dio, name, emoji);

      if (createdTaskList == null) {
        throw Exception("Failed to create task list.");
      }
      taskListsState.add(createdTaskList!);
      return taskListsState;
    });
    return createdTaskList;
  }

  Future<void> deleteTaskList(TaskList taskList) async {
    var taskListsState = _createDeepCopyOfState();

    state = await AsyncValue.guard(() async {
      // Guard validations
      _commonTaskListGuardChecks(taskList, taskListsState);

      // Update state on server
      await _taskListService.deleteTaskList(dio, taskList);

      // Update state locally
      taskListsState.removeWhere((tl) => tl.id == taskList.id);

      return taskListsState;
    });
  }

  Future<void> updateTaskList(TaskList taskList) async {
    var taskListsState = _createDeepCopyOfState();

    state = await AsyncValue.guard(() async {
      // Guard validations
      _commonTaskListGuardChecks(taskList, taskListsState);

      // Update state on server
      await _taskListService.updateTaskList(dio, taskList);

      // Update state locally
      taskListsState[taskListsState.indexWhere((tl) => tl.id == taskList.id)] =
          taskList;

      return taskListsState;
    });
  }

  Future<void> addTaskListRemovedFromGroup(TaskList taskList) async {
    var taskListsState = _createDeepCopyOfState();

    state = await AsyncValue.guard(() async {
      if (taskList.group != null) {
        throw Exception("The provided tasklist is still part of a group.");
      }

      if (taskList.id == null || taskList.id! <= 0) {
        throw Exception("The provided tasklist has an invalid id.");
      }
      // Update state locally
      taskListsState.add(taskList);

      return taskListsState;
    });
  }

  Future<void> removeTaskListAddedToGroup(TaskList taskList) async {
    var taskListsState = _createDeepCopyOfState();

    state = await AsyncValue.guard(() async {
      if (taskList.group == null) {
        throw Exception("The provided tasklist is not part of a group.");
      }

      if (taskList.id == null || taskList.id! <= 0) {
        throw Exception("The provided tasklist has an invalid id.");
      }
      // Update state locally
      taskListsState.removeWhere((tl) => tl.id == taskList.id);

      return taskListsState;
    });
  }

  //
  //--------------------------------------------------------- TASK CRUD METHODS --------------------------------------------------------- //
  //

  Future<void> addTask(TaskList taskList, Task task) async {
    final taskListsState = _createDeepCopyOfState();

    state = await AsyncValue.guard(() async {
      // Guard validations
      _commonTaskListGuardChecks(taskList, taskListsState);

      final affectedTaskListIndex = taskListsState.indexWhere(
        (tl) => tl.id == taskList.id,
      );
      // Create the task on the server
      final createdTask = await _taskService.createTask(
        dio,
        task.text,
        task.dueDate,
        task.reminderDate,
        task.isImportant ?? false,
        taskList.id,
        null,
        TaskCreationContext.list,
      );

      taskListsState[affectedTaskListIndex].tasks?.add(createdTask);
      return taskListsState;
    });
  }

  Future<void> updateTask(TaskList taskList, Task task) async {
    final taskListsState = _createDeepCopyOfState();

    state = await AsyncValue.guard(() async {
      // Guard validations
      _commonTaskListGuardChecks(taskList, taskListsState);

      final affectedTaskListIndex = taskListsState.indexWhere(
        (tl) => tl.id == taskList.id,
      );

      final affectedTaskIndex = taskListsState[affectedTaskListIndex].tasks!
          .indexWhere((t) => t.id == task.id);
      if (affectedTaskIndex == -1) {
        throw Exception("Task not found.");
      }

      //update state on server
      await _taskService.updateTask(dio, task);

      //update state locally
      taskListsState[affectedTaskListIndex].tasks![affectedTaskIndex] = task;

      return taskListsState;
    });
  }
}

//
//--------------------------------------------------------- PROVIDER CLASS --------------------------------------------------------- //
//

final taskListAsyncProvider =
    AsyncNotifierProvider<TaskListAsyncNotifier, List<TaskList>>(
      () => TaskListAsyncNotifier(),
    );
