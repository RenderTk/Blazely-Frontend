import 'package:blazely/models/group_list.dart';
import 'package:blazely/models/task_list.dart';
import 'package:blazely/providers/models_providers/group_list_provider.dart';
import 'package:blazely/providers/models_providers/task_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DynamicTaskListType { completed, important, myDay, planned, assignedToMe }

TaskList importantTaskList(
  List<TaskList> combinedTaskLists,
  List<GroupList> groupLists,
) {
  TaskList importantTasks = TaskList(
    id: -1,
    name: "Important",
    emoji: "📌",
    group: -1,
    tasks: [],
  );
  for (var taskList in combinedTaskLists) {
    for (var task in taskList.tasks!) {
      if (task.isImportant) {
        importantTasks.tasks!.add(task);
      }
    }
  }
  return importantTasks;
}

TaskList myDayTaskList(
  List<TaskList> combinedTaskLists,
  List<GroupList> groupLists,
) {
  TaskList myDayTaskList = TaskList(
    id: -1,
    name: "My Day",
    emoji: "☀️",
    group: -1,
    tasks: [],
  );
  final now = DateTime.now();
  for (var taskList in combinedTaskLists) {
    for (var task in taskList.tasks!) {
      if (task.dueDate != null && DateUtils.isSameDay(task.dueDate!, now)) {
        myDayTaskList.tasks!.add(task);
      }
    }
  }
  return myDayTaskList;
}

TaskList completedTaskList(
  List<TaskList> combinedTaskLists,
  List<GroupList> groupLists,
) {
  TaskList completedTasklist = TaskList(
    id: -1,
    name: "completed",
    emoji: "✅",
    group: -1,
    tasks: [],
  );
  for (var taskList in combinedTaskLists) {
    for (var task in taskList.tasks!) {
      if (task.isCompleted) {
        completedTasklist.tasks!.add(task);
      }
    }
  }
  return completedTasklist;
}

TaskList plannedTaskList(
  List<TaskList> combinedTaskLists,
  List<GroupList> groupLists,
) {
  TaskList plannedTasks = TaskList(
    id: -1,
    name: "Planned",
    emoji: "📆",
    group: -1,
    tasks: [],
  );
  for (var taskList in combinedTaskLists) {
    for (var task in taskList.tasks!) {
      if (task.dueDate != null) {
        plannedTasks.tasks!.add(task);
      }
    }
  }
  return plannedTasks;
}

TaskList assignedToMeTaskList(
  List<TaskList> combinedTaskLists,
  List<GroupList> groupLists,
) {
  TaskList assignedToMeTasks = TaskList(
    id: -1,
    name: "Assigned to me",
    emoji: "👨‍💻",
    group: -1,
    tasks: [],
  );
  return assignedToMeTasks;
}

final dynamicTaskListProvider = Provider.family<TaskList?, DynamicTaskListType>(
  (ref, context) {
    final taskListsAsyncProvider = ref.watch(taskListAsyncProvider).valueOrNull;
    final groupListsAsyncProvider =
        ref.watch(groupListAsyncProvider).valueOrNull;

    final List<TaskList> combinedTaskLists = [
      ...taskListsAsyncProvider ?? [],
      ...groupListsAsyncProvider?.map((e) => e.lists!).expand((e) => e) ?? [],
    ];

    switch (context) {
      case DynamicTaskListType.completed:
        return completedTaskList(combinedTaskLists, groupListsAsyncProvider!);
      case DynamicTaskListType.important:
        return importantTaskList(combinedTaskLists, groupListsAsyncProvider!);
      case DynamicTaskListType.myDay:
        return myDayTaskList(combinedTaskLists, groupListsAsyncProvider!);
      case DynamicTaskListType.planned:
        return plannedTaskList(combinedTaskLists, groupListsAsyncProvider!);
      case DynamicTaskListType.assignedToMe:
        return assignedToMeTaskList(
          combinedTaskLists,
          groupListsAsyncProvider!,
        );
    }
  },
);
