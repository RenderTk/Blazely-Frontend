import 'package:audioplayers/audioplayers.dart';
import 'package:blazely/models/task.dart';
import 'package:blazely/providers/models_providers/group_list_provider.dart';
import 'package:blazely/providers/models_providers/task_list_provider.dart';
import 'package:blazely/providers/models_providers/task_provider.dart';
import 'package:blazely/providers/ui_providers/selected_tasks_provider.dart';
import 'package:blazely/providers/ui_providers/task_selection_mode_provider.dart';
import 'package:blazely/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

  Future toggleIsCompleted(
    WidgetRef ref,
    bool isCompleted,
    AudioPlayer player,
  ) async {
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
    } else {
      await taskListAsyncNotifier.updateTask(
        taskList,
        task.copyWith(isCompleted: isCompleted),
      );
    }
    player.play(AssetSource("sounds/task_success.mp3"));
  }

  Widget _buildLeadingIcon(bool selectionMode, bool isSelected) {
    if (selectionMode) {
      return Icon(
        isSelected ? Icons.circle : Icons.circle_outlined,
        key: ValueKey(isSelected),
        color: isSelected ? Colors.green : Colors.grey.shade400,
      );
    }

    return Icon(
      task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
      key: ValueKey(task.isCompleted),
      color: task.isCompleted ? Colors.green : Colors.grey,
    );
  }

  Future<void> _handleCompletionToggle(
    WidgetRef ref,
    BuildContext context,
    AudioPlayer player,
    Task task,
    bool taskTileSelectionModeIsOn,
  ) async {
    if (taskTileSelectionModeIsOn) {
      return;
    }

    try {
      await toggleIsCompleted(ref, !task.isCompleted, player);
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
  }

  Future<void> _handleIsImportantToggle(
    WidgetRef ref,
    BuildContext context,
    bool taskTileSelectionModeIsOn,
  ) async {
    if (taskTileSelectionModeIsOn) {
      return;
    }

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
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = AudioPlayer();
    final taskTileSelectionModeIsOn = ref.watch(taskSelectionModeProvider);
    final selectedTasksTiles = ref.watch(selectedTasksProvider);
    final isSelected = selectedTasksTiles.any((t) => t.id == task.id);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side:
            isSelected
                ? BorderSide(color: Colors.green, width: 2)
                : BorderSide(color: Colors.transparent),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        enableFeedback: false,
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
            onPressed:
                () async => await _handleCompletionToggle(
                  ref,
                  context,
                  player,
                  task,
                  taskTileSelectionModeIsOn,
                ),
            icon: AnimatedSwitcher(
              duration: 300.ms,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: animation.drive(
                      Tween(begin: const Offset(0.2, 0), end: Offset.zero),
                    ),
                    child: child,
                  ),
                );
              },
              child: _buildLeadingIcon(taskTileSelectionModeIsOn, isSelected)
                  .animate(key: ValueKey(task.isCompleted))
                  .fade(duration: 300.ms)
                  .slide(duration: 300.ms),
            ),
          ),
          trailing: IconButton(
            onPressed:
                () async => await _handleIsImportantToggle(
                  ref,
                  context,
                  taskTileSelectionModeIsOn,
                ),
            icon: AnimatedSwitcher(
              duration: 300.ms,
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                    task.isImportant ? Icons.star : Icons.star_border,
                    key: ValueKey(
                      task.isImportant,
                    ), // must change to trigger switch
                    color: task.isImportant ? Colors.amber : Colors.grey,
                  )
                  .animate(
                    key: ValueKey(
                      task.isImportant,
                    ), // needed so flutter_animate sees the change
                  )
                  .fadeIn(duration: 150.ms)
                  .scale(duration: 300.ms),
            ),
          ),
        ),
      ),
    );
  }
}
