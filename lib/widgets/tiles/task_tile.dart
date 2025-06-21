import 'package:audioplayers/audioplayers.dart';
import 'package:blazely/models/task.dart';
import 'package:blazely/providers/group_list_provider.dart';
import 'package:blazely/providers/task_list_provider.dart';
import 'package:blazely/providers/task_provider.dart';
import 'package:blazely/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskTile extends ConsumerStatefulWidget {
  const TaskTile({super.key, required this.task});

  final Task task;

  @override
  ConsumerState<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends ConsumerState<TaskTile> {
  final player = AudioPlayer();
  bool selectionMode = false;

  Future toggleIsImportant(WidgetRef ref, bool isImportant) async {
    final taskContext = ref.read(taskContextProvider);
    final taskListAsyncNotifier = ref.watch(taskListAsyncProvider.notifier);
    final groupListAsyncNotifier = ref.watch(groupListAsyncProvider.notifier);

    final context = taskContext[widget.task.id]!;
    final groupList = context.groupList;
    final taskList = context.taskList;

    if (groupList != null) {
      await groupListAsyncNotifier.updateTask(
        groupList,
        taskList,
        widget.task.copyWith(isImportant: isImportant),
      );
      return;
    }

    await taskListAsyncNotifier.updateTask(
      taskList,
      widget.task.copyWith(isImportant: isImportant),
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

    final context = taskContext[widget.task.id]!;
    final groupList = context.groupList;
    final taskList = context.taskList;
    if (groupList != null) {
      await groupListAsyncNotifier.updateTask(
        groupList,
        taskList,
        widget.task.copyWith(isCompleted: isCompleted),
      );
      player.play(AssetSource("sounds/task_success.mp3"));
      return;
    }

    player.play(AssetSource("sounds/task_success.mp3"));
    await taskListAsyncNotifier.updateTask(
      taskList,
      widget.task.copyWith(isCompleted: isCompleted),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        enableFeedback: false,
        onTap: () {},
        onLongPress: () {
          setState(() {
            selectionMode = true;
          });
        },
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task.text,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Row(
                children: [
                  if (widget.task.dueDate != null &&
                      widget.task.reminderDate != null) ...[
                    Text(
                      widget.task.formattedDueDate ?? "",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.notifications, size: 15),
                  ],
                  if (widget.task.dueDate != null &&
                      widget.task.reminderDate == null) ...[
                    Text(
                      widget.task.formattedDueDate ?? "",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(width: 5),
                  ],
                  if (widget.task.reminderDate != null &&
                      widget.task.dueDate == null) ...[
                    const Icon(Icons.notifications, size: 15),
                    const SizedBox(width: 5),
                    Text(
                      widget.task.formattedReminderDate ?? "",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ],
              ),
            ],
          ),
          leading: IconButton(
            onPressed: () async {
              final value = widget.task.isCompleted;
              try {
                await toggleIsCompleted(ref, !value, player);
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
              child: Icon(
                    widget.task.isCompleted
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    key: ValueKey(widget.task.isCompleted),
                    color: widget.task.isCompleted ? Colors.green : Colors.grey,
                  )
                  .animate(key: ValueKey(widget.task.isCompleted))
                  .fade(duration: 300.ms)
                  .slide(duration: 300.ms),
            ),
          ),
          trailing: IconButton(
            onPressed: () async {
              final value = widget.task.isImportant;
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
              duration: 300.ms,
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                    widget.task.isImportant ? Icons.star : Icons.star_border,
                    key: ValueKey(
                      widget.task.isImportant,
                    ), // must change to trigger switch
                    color: widget.task.isImportant ? Colors.amber : Colors.grey,
                  )
                  .animate(
                    key: ValueKey(
                      widget.task.isImportant,
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
