import 'package:blazely/models/task.dart';
import 'package:blazely/providers/group_list_provider.dart';
import 'package:blazely/providers/task_list_provider.dart';
import 'package:blazely/providers/task_provider.dart';
import 'package:blazely/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskTile extends ConsumerWidget {
  const TaskTile({super.key, required this.task});

  final Task task;

  Future toggleIsImportant(WidgetRef ref, bool isImportant) async {
    final taskContext = ref.read(taskContextProvider);
    final taskListAsyncNotifier = ref.watch(taskListAsyncProvider.notifier);
    final groupListAsyncNotifier = ref.watch(groupListAsyncProvider.notifier);

    final context = taskContext[task.id]!;
    final groupList = context.groupList;
    final taskList = context.taskList;

    if (groupList != null) {
      await groupListAsyncNotifier.updateTask(
        groupList,
        taskList,
        task.copyWith(isImportant: isImportant),
      );
      return;
    }

    await taskListAsyncNotifier.updateTask(
      taskList,
      task.copyWith(isImportant: isImportant),
    );
  }

  Future toggleIsCompleted(WidgetRef ref, bool isCompleted) async {
    final taskContext = ref.read(taskContextProvider);
    final taskListAsyncNotifier = ref.watch(taskListAsyncProvider.notifier);
    final groupListAsyncNotifier = ref.watch(groupListAsyncProvider.notifier);

    final context = taskContext[task.id]!;
    final groupList = context.groupList;
    final taskList = context.taskList;
    if (groupList != null) {
      await groupListAsyncNotifier.updateTask(
        groupList,
        taskList,
        task.copyWith(isCompleted: isCompleted),
      );
      return;
    }

    await taskListAsyncNotifier.updateTask(
      taskList,
      task.copyWith(isCompleted: isCompleted),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: () {},
      child: Card(
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.text,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Row(
                children: [
                  if (task.dueDate != null && task.reminderDate != null) ...[
                    Text(
                      task.formattedDueDate ?? "",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.notifications, size: 15),
                  ],
                  if (task.dueDate != null && task.reminderDate == null) ...[
                    Text(
                      task.formattedDueDate ?? "",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(width: 5),
                  ],
                  if (task.reminderDate != null && task.dueDate == null) ...[
                    const Icon(Icons.notifications, size: 15),
                    const SizedBox(width: 5),
                    Text(
                      task.formattedReminderDate ?? "",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ],
              ),
            ],
          ),
          leading: IconButton(
            onPressed: () async {
              final value = task.isCompleted;
              try {
                await toggleIsCompleted(ref, !value);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "An error occured when updating the task as completed. Please try again later.",
                      ),
                    ),
                  );
                }
              }
            },
            icon: Icon(
              task.isCompleted
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
            ),
          ),
          trailing: IconButton(
            onPressed: () async {
              final value = task.isImportant;
              try {
                await toggleIsImportant(ref, !value);
              } catch (e) {
                if (context.mounted) {
                  SnackbarHelper.showCustomSnackbar(
                    context: context,
                    message:
                        "An error occured when updating the task as important. Please try again later.",
                  );
                }
              }
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder:
                  (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
              child: Icon(
                (task.isImportant) ? Icons.star : Icons.star_border,
                key: ValueKey(task.isImportant),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
