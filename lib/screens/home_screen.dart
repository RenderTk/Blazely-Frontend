import 'package:blazely/models/profile.dart';
import 'package:blazely/providers/google_auth_provider.dart';
import 'package:blazely/providers/profile_provider.dart';
import 'package:blazely/widgets/group_task_list_tile.dart';
import 'package:blazely/widgets/home_screen_appbar.dart';
import 'package:blazely/widgets/task_action_button_group.dart';
import 'package:blazely/widgets/task_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  List<GroupTaskListTile> buildGroupTaskListTiles(Profile? profile) {
    if (profile == null) {
      return [];
    }
    //Load user groups
    List<GroupTaskListTile> groupTaskListTiles = [];
    for (final groupList in profile.groupLists!) {
      var groupTaskListTile = GroupTaskListTile(
        title: groupList.name,
        taskLists:
            groupList.lists
                ?.map(
                  (taskList) => TaskListTile(
                    title: taskList.name,
                    leadingEmoji: taskList.emoji,
                  ),
                )
                .toList() ??
            [],
      );
      groupTaskListTiles.add(groupTaskListTile);
    }
    return groupTaskListTiles;
  }

  List<TaskListTile> buildTaskListTiles(Profile? profile) {
    if (profile == null) {
      return [];
    }
    //Load user task lists
    List<TaskListTile> taskListTiles = [];
    for (final taskList in profile.lists!) {
      var taskListTile = TaskListTile(
        title: taskList.name,
        leadingEmoji: taskList.emoji,
      );
      taskListTiles.add(taskListTile);
    }
    return taskListTiles;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleAuthNotifier = ref.read(googleAuthProvider.notifier);
    return FutureBuilder(
      future: ref.read(profileProvider.future),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final profile = ref.watch(profileProvider).value;
        return Scaffold(
          appBar: HomeScreenAppBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              TaskActionButtonGroup(),
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
                        ...buildGroupTaskListTiles(profile),

                        //Load user task lists
                        ...buildTaskListTiles(profile),
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
      },
    );
  }
}
