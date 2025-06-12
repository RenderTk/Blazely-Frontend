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
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  void navigateToListScreen(
    BuildContext context,
    TaskList createdTasklist,
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
              taskList: createdTasklist,
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
            ?.map(
              (taskList) => TaskListTile(tasklist: taskList, isDraggable: true),
            )
            .toList();

    final groupListExpansionTile = GroupListExpansionTile(
      groupList: grouplist,
      taskListsTiles: taskListsTiles!,
    );

    return groupListExpansionTile;
  }

  DragTarget<TaskList> _buildDragTargetForGroups(
    GroupListExpansionTile groupListExpansionTile,
    GroupList? sourceGrouplist,
    GroupListAsyncNotifier groupListAsyncNotifier,
    BuildContext context,
  ) {
    // this target will only allow to drop tasklists with no group
    final dragTarget = DragTarget<TaskList>(
      onWillAcceptWithDetails: (details) {
        //TODO: add a way to let user directly change group of tasklist
        final incomingTaskList = details.data;

        if (incomingTaskList.group != null) {
          return false;
        }
        return true;
      },
      onAcceptWithDetails: (details) {
        final incomingTaskList = details.data;
        if (sourceGrouplist == null) {
          return;
        }
        groupListAsyncNotifier.groupTaskLists(sourceGrouplist, [
          incomingTaskList.copyWith(group: sourceGrouplist.id),
        ]);
      },
      builder: (context, candidateData, rejectedData) {
        return groupListExpansionTile;
      },
    );

    return dragTarget;
  }

  DragTarget<TaskList> _buildDragTargetForTaskList(
    List<GroupList>? groupLists,
    GroupListAsyncNotifier groupListAsyncNotifier,
    BuildContext context,
    Widget child,
  ) {
    return DragTarget<TaskList>(
      onWillAcceptWithDetails: (details) {
        final incomingTaskList = details.data;

        // Prevent drop if it doesn't have a group
        if (incomingTaskList.group == null) {
          return false;
        }

        GroupList? sourceGrouplist;
        for (final group in groupLists ?? []) {
          if (group.lists?.any((list) => list.id == incomingTaskList.id) ??
              false) {
            sourceGrouplist = group;
            break;
          }
        }

        // Prevent drop if it doesn't have a group
        if (sourceGrouplist == null) {
          return false;
        }
        return true;
      },
      onAcceptWithDetails: (details) {
        final incomingTaskList = details.data;
        GroupList? sourceGrouplist;
        for (final group in groupLists ?? []) {
          if (group.lists?.any((list) => list.id == incomingTaskList.id) ??
              false) {
            sourceGrouplist = group;
            break;
          }
        }

        if (sourceGrouplist != null) {
          groupListAsyncNotifier.unGroupTaskList(sourceGrouplist, [
            incomingTaskList.copyWith(group: null),
          ]);
        }
      },
      builder: (context, candidateData, rejectedData) {
        return child;
      },
    );
  }

  List<Widget> _buildAllTilesAndFiller(
    BuildContext context,
    GroupListAsyncNotifier groupListAsyncNotifier,
    List<GroupList>? grouplists,
    Map<GroupListExpansionTile, GroupList> groupListExpansionTileToGrouplistMap,
    List<TaskList>? tasklists,
  ) {
    List<GroupListExpansionTile> grouplistExpansionTiles = [];
    List<TaskListTile> taskListTiles = [];

    if (grouplists != null) {
      // build task list tiles with groups
      for (final grouplist in grouplists) {
        final groupListExpansionTile = _buildGroupListExpansionTile(
          grouplist,
          context,
        );

        groupListExpansionTileToGrouplistMap[groupListExpansionTile] =
            grouplist;
        grouplistExpansionTiles.add(groupListExpansionTile);
      }
    }

    if (tasklists != null) {
      // build task list tiles without groups
      for (final tasklist in tasklists) {
        final tasktile = TaskListTile(tasklist: tasklist, isDraggable: true);
        taskListTiles.add(tasktile);
      }
    }

    final fillerWidget = SizedBox.shrink();

    return [...grouplistExpansionTiles, ...taskListTiles, fillerWidget];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskListAsync = ref.watch(taskListAsyncProvider);
    final groupListAsync = ref.watch(groupListAsyncProvider);
    final groupListAsyncNotifier = ref.watch(groupListAsyncProvider.notifier);
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    final Map<GroupListExpansionTile, GroupList>
    groupListExpansionTileToGrouplistMap = {};

    final allTiles = _buildAllTilesAndFiller(
      context,
      groupListAsyncNotifier,
      groupListAsync.valueOrNull,
      groupListExpansionTileToGrouplistMap,
      taskListAsync.valueOrNull,
    );

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          TaskListTileGroup()
              .animate()
              .fadeIn(duration: 600.ms, curve: Curves.easeOutQuart)
              .slideY(
                begin: -0.3,
                end: 0,
                duration: 600.ms,
                curve: Curves.easeOutBack,
              ),
          Divider(thickness: 0.3, color: Colors.grey.shade400)
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms)
              .scaleX(
                begin: 0,
                end: 1,
                duration: 800.ms,
                curve: Curves.easeOutExpo,
              ),

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // constraints.maxHeight is the total available height for ListView
                double availableHeight = constraints.maxHeight;

                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: allTiles.length,
                  itemBuilder: (context, index) {
                    final tile = allTiles[index];

                    //
                    // this is the drag target task list tiles with no group
                    //
                    if (tile is GroupListExpansionTile) {
                      GroupList? sourceGrouplist =
                          groupListExpansionTileToGrouplistMap[tile];

                      return _buildDragTargetForGroups(
                        tile,
                        sourceGrouplist,
                        groupListAsyncNotifier,
                        context,
                      );
                    }

                    //
                    // this is the drag target for task list tiles with groups
                    //
                    if (tile is TaskListTile) {
                      return _buildDragTargetForTaskList(
                        groupListAsync.valueOrNull,
                        groupListAsyncNotifier,
                        context,
                        tile,
                      );
                    }

                    ///
                    /// this is the filler widget. Also a drag target for task list tiles with groups
                    ///
                    if (tile is SizedBox) {
                      double estimatedItemHeight =
                          60.0; // Adjust based on your average item height
                      int otherItemsCount =
                          allTiles.where((t) => t is! SizedBox).length;
                      double usedHeight = otherItemsCount * estimatedItemHeight;

                      // Calculate remaining height
                      double remainingHeight = availableHeight - usedHeight;

                      // Ensure minimum height and don't exceed available space
                      double finalHeight = remainingHeight.clamp(
                        100.0,
                        availableHeight * 0.8,
                      );
                      return SizedBox(
                        height: finalHeight,
                        width: double.maxFinite,
                        child: _buildDragTargetForTaskList(
                          groupListAsync.valueOrNull,
                          groupListAsyncNotifier,
                          context,
                          tile,
                        ),
                      );
                    }
                    return null;
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 50,
        padding: const EdgeInsets.all(0),
        shape: const CircularNotchedRectangle(),
        child: Row(
          children: [
            TextButton.icon(
              onPressed: () async {
                final createdTasklist = await showDialog(
                  context: context,
                  builder:
                      (context) => Dialog(
                            insetPadding: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            child: ManageListForm(
                              type: ManageListFormType.create,
                              taskList: null,
                            ),
                          )
                          .animate()
                          .scale(duration: 250.ms)
                          .fadeIn(duration: 300.ms),
                );

                if ((createdTasklist != null && createdTasklist is TaskList) &&
                    context.mounted) {
                  navigateToListScreen(context, createdTasklist, null);
                }
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
                            backgroundColor:
                                Theme.of(context).colorScheme.surface,
                            child: ManageGroupFrom(
                              type: ManagGroupFormType.create,
                              groupList: null,
                            ),
                          )
                          .animate()
                          .scale(duration: 250.ms)
                          .fadeIn(duration: 300.ms),
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
