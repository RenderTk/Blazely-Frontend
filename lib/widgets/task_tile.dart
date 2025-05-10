import 'package:blazely/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskTile extends ConsumerWidget {
  const TaskTile({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {},
      child: Card(
        child: ListTile(
          title: Text(task.text!, maxLines: 3, overflow: TextOverflow.ellipsis),
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.circle_outlined),
          ),
          trailing: IconButton(onPressed: () {}, icon: Icon(Icons.star_border)),
        ),
      ),
    );
  }
}
