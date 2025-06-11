import 'package:blazely/models/group_list.dart';
import 'package:blazely/models/task_list.dart';
import 'package:blazely/providers/group_list_provider.dart';
import 'package:blazely/screens/list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListTile extends ConsumerWidget {
  final TaskList tasklist;
  final Icon? icon;
  final VoidCallback? onPressed;

  const TaskListTile({
    super.key,
    required this.tasklist,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grouplists = ref.read(groupListAsyncProvider).valueOrNull ?? [];
    GroupList? grouplist;
    for (final group in grouplists) {
      if (group.lists?.any((list) => list.id == tasklist.id) ?? false) {
        grouplist = group;
        break; // Stop searching once we find the matching group
      }
    }

    return Draggable<TaskList>(
      data: tasklist,
      feedback: Container(
        width: 200,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Card(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: const BorderSide(color: Colors.transparent),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tasklist.emoji,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(width: 10, height: 10),
                Text(
                  tasklist.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: SizedBox(
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 12),
          leading:
              icon ??
              Text(
                tasklist.emoji,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
          title: Text(
            tasklist.name,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          onTap:
              onPressed ??
              () => navigateToListScreen(context, tasklist, grouplist),
        ),
      ),
    );
  }
}

void navigateToListScreen(
  BuildContext context,
  TaskList taskList,
  GroupList? groupList,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder:
          (context) => ListScreen(
            defaultImageWhenEmpty: Image.asset(
              "assets/images/empty_tasks_custom_list.png",
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
            defaultMsgWhenEmpty: "There are no tasks in this list.",
            showShareTaskButton: true,
            taskList: taskList,
            groupList: groupList,
          ),
    ),
  );
}
