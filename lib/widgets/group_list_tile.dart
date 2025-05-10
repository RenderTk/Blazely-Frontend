import 'package:blazely/widgets/task_list_tile.dart';
import 'package:flutter/material.dart';

class GroupListTile extends StatelessWidget {
  const GroupListTile({
    super.key,
    required this.title,
    required this.taskLists,
  });

  final String title;
  final List<TaskListTile> taskLists;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: const Icon(Icons.library_books_outlined, color: Colors.blueGrey),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      tilePadding: EdgeInsets.symmetric(horizontal: 12),
      childrenPadding: EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.transparent,
      collapsedBackgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 300, //Limits the height to 300
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize:
                  MainAxisSize.min, //Only take as much space as needed
              children: taskLists,
            ),
          ),
        ),
      ],
    );
  }
}
