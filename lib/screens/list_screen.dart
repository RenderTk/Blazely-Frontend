import 'package:blazely/models/task_list.dart';
import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({
    super.key,
    this.leadingEmoji,
    required this.title,
    required this.defaultImageWhenEmpty,
    required this.defaultMsgWhenEmpty,
    required this.showShareTaskButton,
    required this.taskList,
  });

  final String title;
  final String? leadingEmoji;
  final Image defaultImageWhenEmpty;
  final String defaultMsgWhenEmpty;
  final bool showShareTaskButton;
  final TaskList? taskList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (leadingEmoji != null) ...[
              Text(
                leadingEmoji!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(width: 10),
            ],
            Flexible(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        actions: [
          if (showShareTaskButton)
            IconButton(
              icon: const Icon(Icons.person_add_alt_outlined),
              onPressed: () {},
            ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (taskList?.tasks?.isEmpty ?? true) ...[
              defaultImageWhenEmpty,
              const SizedBox(height: 20),
              Text(
                defaultMsgWhenEmpty,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ] else ...[
              Text(""),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}
