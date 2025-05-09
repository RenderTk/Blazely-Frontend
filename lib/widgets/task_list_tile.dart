import 'package:flutter/material.dart';

class TaskListTile extends StatelessWidget {
  const TaskListTile({
    super.key,
    required this.title,
    required this.leadingEmoji,
  });

  final String title;
  final String leadingEmoji;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
      // leading: const Icon(Icons.list_alt_outlined, color: Color(0xFF5C6BC0)),
      leading: Text(leadingEmoji, style: Theme.of(context).textTheme.bodyLarge),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
