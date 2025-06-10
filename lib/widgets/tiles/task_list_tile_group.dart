import 'package:blazely/providers/dynamic_task_list_provider.dart';
import 'package:blazely/screens/list_screen.dart';
import 'package:blazely/widgets/tiles/task_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListTileGroup extends ConsumerWidget {
  const TaskListTileGroup({super.key});

  void navigateToListScreen(
    BuildContext context,
    String title,
    String imageAssetPath,
    String defaultMsgWhenEmpty,
    DynamicTaskListType dynamicTaskListType,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ListScreen(
              defaultImageWhenEmpty: Image.asset(
                imageAssetPath,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
              defaultMsgWhenEmpty: defaultMsgWhenEmpty,
              showShareTaskButton: false,
              dynamicTaskListType: dynamicTaskListType,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define color pairs for light/dark modes
    final myDayColorDark = const Color.fromARGB(255, 234, 205, 126);
    final myDayColorLight = const Color.fromARGB(255, 172, 131, 7);

    final importantColorDark = const Color(0xFFFF9E9E);
    final importantColorLight = const Color.fromARGB(255, 184, 76, 76);

    final plannedColorDark = const Color.fromARGB(255, 253, 205, 145);
    final plannedColorLight = const Color.fromARGB(255, 117, 90, 55);

    final completedColorDark = const Color.fromARGB(255, 30, 247, 139);
    final completedColorLight = const Color.fromARGB(255, 18, 164, 94);

    final assignedColorDark = const Color.fromARGB(255, 176, 222, 245);
    final assignedColorLight = Colors.blueGrey;

    final habitsColorDark = Colors.deepOrangeAccent.shade100;
    final habitsColorLight = Colors.deepOrangeAccent;

    return Column(
      children: [
        TaskListTile.icon(
          title: "My Day",
          icon: Icons.sunny,
          iconColor: isDarkMode ? myDayColorDark : myDayColorLight,
          onPressed: () {
            navigateToListScreen(
              context,
              "My Day",
              "assets/images/empty_my_day_list.png",
              "Tasks due today will appear here",
              DynamicTaskListType.myDay,
            );
          },
        ),
        TaskListTile.icon(
          title: "Important",
          icon: Icons.star_border_outlined,
          iconColor: isDarkMode ? importantColorDark : importantColorLight,
          onPressed: () {
            navigateToListScreen(
              context,
              "Important",
              "assets/images/empty_important_list.png",
              "Tasks marked as important will appear here",
              DynamicTaskListType.important,
            );
          },
        ),
        TaskListTile.icon(
          title: "Planned",
          icon: Icons.calendar_month_outlined,
          iconColor: isDarkMode ? plannedColorDark : plannedColorLight,
          onPressed: () {
            navigateToListScreen(
              context,
              "Planned",
              "assets/images/empty_planned_list.png",
              "Tasks with a due date will appear here",
              DynamicTaskListType.planned,
            );
          },
        ),
        TaskListTile.icon(
          title: "Completed",
          icon: Icons.check_circle_outline,
          iconColor: isDarkMode ? completedColorDark : completedColorLight,
          onPressed: () {
            navigateToListScreen(
              context,
              "Completed",
              "assets/images/empty_completed_list.png",
              "Completed tasks will appear here",
              DynamicTaskListType.completed,
            );
          },
        ),
        TaskListTile.icon(
          title: "Assigned to Me",
          icon: Icons.person_2_outlined,
          iconColor: isDarkMode ? assignedColorDark : assignedColorLight,
          onPressed: () {
            navigateToListScreen(
              context,
              "Assigned to Me",
              "assets/images/empty_assigned_list.png",
              "Tasks that are assigned to you will appear here",
              DynamicTaskListType.assignedToMe,
            );
          },
        ),
        TaskListTile.icon(
          title: "Habits",
          icon: Icons.emoji_emotions_outlined,
          iconColor: isDarkMode ? habitsColorDark : habitsColorLight,
          onPressed: () {
            // TODO: implement habits screen
            // navigateToListScreen(
            //   context,
            //   "Habits",
            //   "assets/images/blazely_logo.png",
            //   "Habit tracker coming soon!",
            // );
          },
        ),
      ],
    );
  }
}
