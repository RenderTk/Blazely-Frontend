import 'package:blazely/models/group_list.dart';
import 'package:blazely/models/task_list.dart';
import 'package:blazely/providers/group_list_provider.dart';
import 'package:blazely/providers/task_list_provider.dart';
import 'package:blazely/screens/list_screen.dart';
import 'package:blazely/utils/snackbar_helper.dart';
import 'package:blazely/widgets/forms/manage_group_from.dart';
import 'package:blazely/widgets/forms/manage_list_form.dart';
import 'package:blazely/widgets/tiles/group_list_tile.dart';
import 'package:blazely/widgets/appbars/home_screen_appbar.dart';
import 'package:blazely/widgets/animations/blazely_loading_widget.dart';
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
              taskListId: taskList.id ?? -1,
              groupListId: groupList?.id,
            ),
      ),
    );
  }

  List<GroupListTile> buildGroupTaskListTiles(
    List<GroupList>? groupLists,
    BuildContext context,
  ) {
    if (groupLists == null) {
      return [];
    }
    //Load user groups
    List<GroupListTile> groupTaskListTiles = [];
    for (final groupList in groupLists) {
      var groupTaskListTile = GroupListTile(
        title: groupList.name,
        groupList: groupList,
        taskListsTiles:
            groupList.lists
                ?.map(
                  (taskList) => TaskListTile(
                    title: taskList.name,
                    leadingEmoji: taskList.emoji,
                    onPressed: () {
                      navigateToListScreen(context, taskList, groupList);
                    },
                  ),
                )
                .toList() ??
            [],
      );
      groupTaskListTiles.add(groupTaskListTile);
    }
    return groupTaskListTiles;
  }

  List<TaskListTile> buildTaskListTiles(
    List<TaskList>? taskLists,
    BuildContext context,
  ) {
    if (taskLists == null) {
      return [];
    }
    //Load user task lists
    List<TaskListTile> taskListTiles = [];
    for (final taskList in taskLists) {
      var taskListTile = TaskListTile(
        title: taskList.name,
        leadingEmoji: taskList.emoji,
        onPressed: () {
          navigateToListScreen(context, taskList, null);
        },
      );
      taskListTiles.add(taskListTile);
    }
    return taskListTiles;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskListAsync = ref.watch(taskListAsyncProvider);
    final groupListAsync = ref.watch(groupListAsyncProvider);
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;

    // Show loading if any are loading
    if (taskListAsync.isLoading || groupListAsync.isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlazelyLoadingWidget(
          loadingText: 'Loading...',
          primaryColor: Theme.of(context).primaryColor,
          secondaryColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }

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
          TaskListTileGroup(),
          Divider(thickness: 0.3, color: Colors.grey.shade400),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),

                child: Column(
                  children: [
                    //Load user groups
                    ...buildGroupTaskListTiles(groupListAsync.value, context),

                    //Load user task lists
                    ...buildTaskListTiles(taskListAsync.value, context),
                  ],
                ),
              ),
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
