import 'package:blazely/models/group_list.dart';
import 'package:blazely/models/task_list.dart';
import 'package:blazely/providers/group_list_provider.dart';
import 'package:blazely/screens/list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListTile extends ConsumerWidget {
  final TaskList tasklist;
  final bool isDraggable;
  final Icon? icon;
  final VoidCallback? onPressed;

  const TaskListTile({
    super.key,
    required this.tasklist,
    required this.isDraggable,
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

    return isDraggable
        ? LongPressDraggable<TaskList>(
          data: tasklist,
          feedback: Container(
            width: 200,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.95),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.9),
                      Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 5.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tasklist.emoji,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          tasklist.name,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.9),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ).animate().scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.0, 1.0),
            duration: 250.ms,
            curve: Curves.easeInOut,
          ),
          onDraggableCanceled: (velocity, offset) {},
          childWhenDragging: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: SizedBox(
            child: ListTile(
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              leading:
                  icon ??
                  Text(
                    tasklist.emoji,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
              title: Text(
                tasklist.name,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              onTap:
                  onPressed ??
                  () => navigateToListScreen(context, tasklist, grouplist),
            ),
          ),
        )
        : ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -3.5),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          leading:
              icon ??
              Text(
                tasklist.emoji,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          title: Text(
            tasklist.name,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          onTap:
              onPressed ??
              () => navigateToListScreen(context, tasklist, grouplist),
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
