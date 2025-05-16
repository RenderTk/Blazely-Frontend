import 'package:blazely/models/task.dart';
import 'package:blazely/providers/group_list_provider.dart';
import 'package:blazely/providers/task_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskContext {
  final int taskId;
  final int taskListId;
  final int? groupListId;

  TaskContext({
    required this.taskId,
    required this.taskListId,
    this.groupListId,
  });
}

final taskProvider = Provider.family<Task?, TaskContext>((ref, context) {
  if (context.groupListId != null) {
    final groupListsAsync = ref.watch(groupListAsyncProvider).valueOrNull;

    final selectedGroup =
        groupListsAsync
            ?.where((group) => group.id == context.groupListId)
            .firstOrNull;

    final selectedList =
        selectedGroup?.lists
            ?.where((list) => list.id == context.taskListId)
            .firstOrNull;

    final selectedTask =
        selectedList?.tasks
            ?.where((task) => task.id == context.taskId)
            .firstOrNull;

    return selectedTask;
  } else {
    final taskListsAsync = ref.watch(taskListAsyncProvider).valueOrNull;

    final selectedList =
        taskListsAsync
            ?.where((list) => list.id == context.taskListId)
            .firstOrNull;

    final selectedTask =
        selectedList?.tasks
            ?.where((task) => task.id == context.taskId)
            .firstOrNull;

    return selectedTask;
  }
});
