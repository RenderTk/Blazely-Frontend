import 'package:blazely/models/group_list.dart';
import 'package:blazely/models/task.dart';
import 'package:blazely/models/task_list.dart';
import 'package:blazely/providers/group_list_provider.dart';
import 'package:blazely/providers/task_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskContext {
  final Task task;
  final TaskList taskList;
  final GroupList? groupList;

  TaskContext({required this.task, required this.taskList, this.groupList});
}

final taskProvider = Provider.family<Task?, TaskContext>((ref, context) {
  if (context.groupList != null) {
    final groupListsAsync = ref.watch(groupListAsyncProvider).valueOrNull;

    final selectedGroup =
        groupListsAsync
            ?.where((group) => group.id == context.groupList?.id)
            .firstOrNull;

    final selectedList =
        selectedGroup?.lists
            ?.where((tasklist) => tasklist.id == context.taskList.id)
            .firstOrNull;

    final selectedTask =
        selectedList?.tasks
            ?.where((task) => task.id == context.task.id)
            .firstOrNull;

    return selectedTask;
  } else {
    final taskListsAsync = ref.watch(taskListAsyncProvider).valueOrNull;

    final selectedList =
        taskListsAsync
            ?.where((tasklist) => tasklist.id == context.taskList.id)
            .firstOrNull;

    final selectedTask =
        selectedList?.tasks
            ?.where((task) => task.id == context.task.id)
            .firstOrNull;

    return selectedTask;
  }
});
