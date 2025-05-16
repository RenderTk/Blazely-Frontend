import 'package:blazely/models/task.dart';
import 'package:blazely/providers/group_list_provider.dart';
import 'package:blazely/providers/task_list_provider.dart';
import 'package:blazely/providers/task_provider.dart';
import 'package:blazely/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskTile extends ConsumerWidget {
  const TaskTile({
    super.key,
    required this.taskId,
    required this.taskListId,
    this.groupListId,
  });

  final int taskId;
  final int taskListId;
  final int? groupListId;

  Future toggleIsImportant(WidgetRef ref, bool isImportant) async {
    final taskListAsyncNotifier = ref.watch(taskListAsyncProvider.notifier);
    final groupListAsyncNotifier = ref.watch(groupListAsyncProvider.notifier);

    if (groupListId != null) {
      await groupListAsyncNotifier.toggleIsImportantOnTask(
        groupListId!,
        taskListId,
        taskId,
        isImportant,
      );
      return;
    }

    await taskListAsyncNotifier.toggleIsImportantOnTask(
      taskListId,
      taskId,
      isImportant,
    );
  }

  Future toggleIsCompleted(WidgetRef ref, bool isCompleted) async {
    final taskListAsyncNotifier = ref.watch(taskListAsyncProvider.notifier);
    final groupListAsyncNotifier = ref.watch(groupListAsyncProvider.notifier);

    if (groupListId != null) {
      await groupListAsyncNotifier.toggleIsCompletedOnTask(
        groupListId!,
        taskListId,
        taskId,
        isCompleted,
      );
      return;
    }

    await taskListAsyncNotifier.toggleIsCompletedOnTask(
      taskListId,
      taskId,
      isCompleted,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(
      taskProvider(
        TaskContext(
          taskId: taskId,
          taskListId: taskListId,
          groupListId: groupListId,
        ),
      ),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: () {},
      child: Card(
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task?.text ?? "",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Row(
                children: [
                  if (task?.dueDate != null && task?.reminderDate != null) ...[
                    Text(
                      task?.formattedDueDate ?? "",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.notifications, size: 15),
                  ],
                  if (task?.dueDate != null && task?.reminderDate == null) ...[
                    Text(
                      task?.formattedDueDate ?? "",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(width: 5),
                  ],
                  if (task?.reminderDate != null && task?.dueDate == null) ...[
                    const Icon(Icons.notifications, size: 15),
                    const SizedBox(width: 5),
                    Text(
                      task?.formattedReminderDate ?? "",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ],
              ),
            ],
          ),
          leading: IconButton(
            onPressed: () async {
              final value = task?.isCompleted ?? false;
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
              task?.isCompleted ?? false
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
            ),
          ),
          trailing: IconButton(
            onPressed: () async {
              final value = task?.isImportant ?? false;
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
                (task?.isImportant ?? false) ? Icons.star : Icons.star_border,
                key: ValueKey(task?.isImportant),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
