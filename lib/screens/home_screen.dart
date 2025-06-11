import 'package:blazely/models/group_list.dart';
import 'package:blazely/models/task_list.dart';
import 'package:blazely/providers/group_list_provider.dart';
import 'package:blazely/providers/task_list_provider.dart';
import 'package:blazely/screens/list_screen.dart';
import 'package:blazely/utils/snackbar_helper.dart';
import 'package:blazely/widgets/forms/manage_group_form.dart';
import 'package:blazely/widgets/forms/manage_list_form.dart';
import 'package:blazely/widgets/appbars/home_screen_appbar.dart';
import 'package:blazely/widgets/tiles/group_list_expansion_tile.dart';
import 'package:blazely/widgets/tiles/task_list_tile_group.dart';
import 'package:blazely/widgets/tiles/task_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
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

  GroupListExpansionTile _buildGroupListExpansionTile(
    GroupList grouplist,
    BuildContext context,
  ) {
    final taskListsTiles =
        grouplist.lists
            ?.map((taskList) => TaskListTile(tasklist: taskList))
            .toList();

    final groupListExpansionTile = GroupListExpansionTile(
      groupList: grouplist,
      taskListsTiles: taskListsTiles!,
    );

    return groupListExpansionTile;
  }

  DragTarget<TaskList> _buildDragTargetForGroups(
    GroupList grouplist,
    GroupListAsyncNotifier groupListAsyncNotifier,
    BuildContext context,
  ) {
    final groupListExpansionTile = _buildGroupListExpansionTile(
      grouplist,
      context,
    );

    // this target will only allow to drop tasklists with no group
    final dragTarget = DragTarget<TaskList>(
      onWillAcceptWithDetails: (details) {
        //TODO: add a way to let user directly change group of tasklist

        if (details.data.group != null) {
          return false;
        }
        return true;
      },
      onAcceptWithDetails: (details) {
        groupListAsyncNotifier.groupTaskLists(grouplist, [
          details.data.copyWith(group: grouplist.id),
        ]);
      },
      builder: (context, candidateData, rejectedData) {
        return groupListExpansionTile;
      },
    );

    return dragTarget;
  }

  int _getTotalItemCount(
    List<GroupList>? grouplists,
    List<TaskList>? tasklists,
  ) {
    final groupCount = grouplists?.length ?? 0;
    final taskCount = tasklists?.length ?? 0;
    return groupCount + taskCount;
  }

  Widget _buildUnifiedTaskListTiles(
    int index,
    BuildContext context,
    GroupListAsyncNotifier groupListAsyncNotifier,
    List<GroupList>? grouplists,
    List<TaskList>? tasklists,
  ) {
    final groupCount = grouplists?.length ?? 0;

    if (index < groupCount) {
      // This is a group item
      final groupList = grouplists![index];
      return _buildDragTargetForGroups(
        groupList,
        groupListAsyncNotifier,
        context,
      );
    } else {
      // This is a task item
      final taskIndex = index - groupCount;
      final tasklist = tasklists![taskIndex];
      return TaskListTile(tasklist: tasklist);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskListAsync = ref.watch(taskListAsyncProvider);
    final groupListAsync = ref.watch(groupListAsyncProvider);
    final groupListAsyncNotifier = ref.watch(groupListAsyncProvider.notifier);
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;

    //if error when loading home screen, show snackbar
    ref.listen(taskListAsyncProvider, (previous, next) {
      if (next is AsyncError && isCurrent) {
        SnackbarHelper.showCustomSnackbar(
          context: context,
          message:
              "Something went wrong loading your lists, please try again later.",
          type: SnackbarType.error,
        );
        Logger().e(next.error);
      }
    });

    ref.listen(groupListAsyncProvider, (previous, next) {
      if (next is AsyncError && isCurrent) {
        SnackbarHelper.showCustomSnackbar(
          context: context,
          message:
              "Something went wrong loading your groups, please try again later.",
          type: SnackbarType.error,
        );
        Logger().e(next.error);
      }
    });

    return Scaffold(
      appBar: HomeScreenAppBar(),
      body: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            TaskListTileGroup(),
            Divider(thickness: 0.3, color: Colors.grey.shade400),

            // this target will only allow to drop tasklists with no group
            Expanded(
              child: DragTarget<TaskList>(
                onWillAcceptWithDetails: (details) {
                  final incomingTaskList = details.data;

                  if (incomingTaskList.group == null) {
                    return false;
                  }
                  GroupList? grouplist;
                  for (final group in groupListAsync.valueOrNull ?? []) {
                    if (group.lists?.any(
                          (list) => list.id == incomingTaskList.id,
                        ) ??
                        false) {
                      grouplist = group;
                      break;
                    }
                  }
                  if (grouplist == null) {
                    return false;
                  }
                  return true;
                },
                onAcceptWithDetails: (details) {
                  final incomingTaskList = details.data;
                  GroupList? grouplist;
                  for (final group in groupListAsync.valueOrNull ?? []) {
                    if (group.lists?.any(
                          (list) => list.id == incomingTaskList.id,
                        ) ??
                        false) {
                      grouplist = group;
                      break;
                    }
                  }
                  groupListAsyncNotifier.unGroupTaskList(grouplist!, [
                    incomingTaskList.copyWith(group: null),
                  ]);
                },
                builder: (context, candidateData, rejectedData) {
                  return ListView.builder(
                    itemCount: _getTotalItemCount(
                      groupListAsync.value,
                      taskListAsync.value,
                    ),
                    itemBuilder: (context, index) {
                      return _buildUnifiedTaskListTiles(
                        index,
                        context,
                        groupListAsyncNotifier,
                        groupListAsync.value,
                        taskListAsync.value,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 50,
        padding: const EdgeInsets.all(0),
        shape: const CircularNotchedRectangle(),
        child: Row(
          children: [
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => Dialog(
                        insetPadding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        child: ManageListForm(
                          type: ManageListFormType.create,
                          taskList: null,
                        ),
                      ),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(
                "New list",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(),
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => Dialog(
                        insetPadding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        child: ManageGroupFrom(
                          type: ManagGroupFormType.create,
                          groupList: null,
                        ),
                      ),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(
                "New group",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
