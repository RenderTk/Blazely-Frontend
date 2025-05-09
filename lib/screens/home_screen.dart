import 'package:blazely/providers/google_auth_provider.dart';
import 'package:blazely/widgets/group_task_list_tile.dart';
import 'package:blazely/widgets/home_screen_appbar.dart';
import 'package:blazely/widgets/task_action_button_group.dart';
import 'package:blazely/widgets/task_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final googleAuthNotifier = ref.watch(googleAuthProvider.notifier);

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
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),

                  child: Column(
                    children: [
                      GroupTaskListTile(
                        title: "Workouts",
                        taskLists: [
                          TaskListTile(
                            title: "Chest & Triceps workout",
                            leadingEmoji: "🏋️‍♀️",
                          ),
                          TaskListTile(
                            title: "Back & Biceps workout",
                            leadingEmoji: "🏋️‍♀️",
                          ),
                          TaskListTile(
                            title: "Legs workout",
                            leadingEmoji: "🏋️‍♀️",
                          ),
                          TaskListTile(
                            title: "Arms workout",
                            leadingEmoji: "🏋️‍♀️",
                          ),
                        ],
                      ),
                      GroupTaskListTile(
                        title: "Blazely",
                        taskLists: [
                          TaskListTile(
                            title: "Frontend pending tasks",
                            leadingEmoji: "👨‍💻",
                          ),
                          TaskListTile(
                            title: "Backend pending tasks",
                            leadingEmoji: "👨‍💻",
                          ),
                        ],
                      ),
                      TaskListTile(title: "Shopping list", leadingEmoji: "🛒"),
                      TaskListTile(
                        title: "Morning routine",
                        leadingEmoji: "🚿",
                      ),
                    ],
                  ),
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
              onPressed: () {},
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
