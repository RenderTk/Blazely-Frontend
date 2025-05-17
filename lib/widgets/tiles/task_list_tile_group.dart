import 'package:blazely/screens/list_screen.dart';
import 'package:blazely/widgets/tiles/task_list_tile.dart';
import 'package:flutter/material.dart';

//TODO: remove n fix when ListScreen have constructor that accepts a TaskList instance instead of just a taskListId
const int PLACE_HOLDER_ID = -1;

class TaskListTileGroup extends StatelessWidget {
  const TaskListTileGroup({super.key});

  void navigateToListScreen(
    BuildContext context,
    String title,
    String imageAssetPath,
    String defaultMsgWhenEmpty,
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
              taskListId: PLACE_HOLDER_ID,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            );
          },
        ),
        TaskListTile.icon(
          title: "Habits",
          icon: Icons.emoji_emotions_outlined,
          iconColor: isDarkMode ? habitsColorDark : habitsColorLight,
          onPressed: () {
            navigateToListScreen(
              context,
              "Habits",
              "assets/images/blazely_logo.png",
              "Habit tracker coming soon!",
            );
          },
        ),
      ],
    );
  }
}
