import 'package:blazely/widgets/task_action_button.dart';
import 'package:flutter/material.dart';

class TaskActionButtonGroup extends StatelessWidget {
  const TaskActionButtonGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TaskActionButton(
          label: "My Day",
          icon: Icons.sunny,
          iconColor: const Color(0xFFE6C153),
          onPressed: () {},
        ),
        TaskActionButton(
          label: "Important",
          icon: Icons.star_border_outlined,
          iconColor: const Color(0xFFEA9090),
          onPressed: () {},
        ),
        TaskActionButton(
          label: "Planned",
          icon: Icons.calendar_month_outlined,
          iconColor: const Color(0xFFE5B77C),
          onPressed: () {},
        ),
        TaskActionButton(
          label: "Completed",
          icon: Icons.check_circle_outline,
          iconColor: const Color(0xFF158C53),
          onPressed: () {},
        ),
        TaskActionButton(
          label: "Assigned to Me",
          icon: Icons.person_2_outlined,
          iconColor: Colors.blueGrey,
          onPressed: () {},
        ),
        TaskActionButton(
          label: "Tasks",
          icon: Icons.topic_outlined,
          iconColor: Colors.deepPurpleAccent,
          onPressed: () {},
        ),
        TaskActionButton(
          label: "Habits",
          icon: Icons.emoji_emotions_outlined,
          iconColor: Colors.deepOrangeAccent,
          onPressed: () {},
        ),
      ],
    );
  }
}
