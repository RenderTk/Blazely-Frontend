import 'package:blazely/models/group_list.dart';
import 'package:blazely/models/task_list.dart';
import 'package:blazely/providers/google_auth_provider.dart';
import 'package:blazely/providers/group_list_provider.dart';
import 'package:blazely/providers/task_list_provider.dart';
import 'package:blazely/screens/list_screen.dart';
import 'package:blazely/widgets/group_list_tile.dart';
import 'package:blazely/widgets/home_screen_appbar.dart';
import 'package:blazely/widgets/loading_widget.dart';
import 'package:blazely/widgets/task_list_tile_group.dart';
import 'package:blazely/widgets/task_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void navigateToListScreen(BuildContext context, TaskList taskList) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ListScreen(
              title: taskList.name,
              defaultImageWhenEmpty: Image.asset(
                "assets/images/empty_tasks_custom_list.png",
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
              defaultMsgWhenEmpty: "There are no tasks in this list.",
              showShareTaskButton: true,
              taskList: taskList,
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
        taskLists:
            groupList.lists
                ?.map(
                  (taskList) => TaskListTile(
                    title: taskList.name,
                    leadingEmoji: taskList.emoji,
                    onPressed: () {
                      navigateToListScreen(context, taskList);
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
          navigateToListScreen(context, taskList);
        },
      );
      taskListTiles.add(taskListTile);
    }
    return taskListTiles;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleAuthNotifier = ref.read(googleAuthProvider.notifier);
    final taskListAsync = ref.watch(taskListAsyncProvider);
    final groupListAsync = ref.watch(groupListAsyncProvider);

    // Show loading if any are loading
    if (taskListAsync.isLoading || groupListAsync.isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: ModernLoadingWidget(
          loadingText: 'Loading your tasks...',
          icon: Icons.task_alt, // You can change this to your app's icon
          primaryColor: Theme.of(context).primaryColor,
          secondaryColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }

    // Show error if any have errors
    if (taskListAsync.hasError || groupListAsync.hasError) {
      return Center(
        child: Column(
          children: [
            Image.asset(
              "assets/images/error_ocurred.png",
              height: 200,
              width: 200,
            ),
            SizedBox(height: 20),
            Text("Something went wrong. Please try again later."),
          ],
        ),
      );
    }

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
                googleAuthNotifier.googleSignOut();
              },
              icon: const Icon(Icons.add),
              label: const Text("New list"),
            ),
            Spacer(),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text("New group"),
            ),
          ],
        ),
      ),
    );
  }
}
