import 'package:flutter/material.dart';

class TaskListTile extends StatelessWidget {
  final String title;
  final String? leadingEmoji;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback onPressed;

  const TaskListTile({
    super.key,
    required this.title,
    required this.leadingEmoji,
    required this.onPressed,
    this.icon,
    this.iconColor,
  });

  const TaskListTile.icon({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
    this.leadingEmoji,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
      leading:
          leadingEmoji != null
              ? Text(
                leadingEmoji!,
                style: Theme.of(context).textTheme.bodyLarge,
              )
              : Icon(icon, color: iconColor, size: 25),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      onTap: onPressed,
    );
  }
}
