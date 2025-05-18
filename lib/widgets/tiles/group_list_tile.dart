import 'package:blazely/models/group_list.dart';
import 'package:blazely/widgets/forms/manage_group_from.dart';
import 'package:blazely/widgets/tiles/task_list_tile.dart';
import 'package:flutter/material.dart';

enum PopMenuValues {
  addOrRemoveTaskList,
  changeName,
  unGroupLists,
  deleteGroup,
}

class GroupListTile extends StatefulWidget {
  const GroupListTile({
    super.key,
    required this.title,
    required this.taskListsTiles,
    required this.group,
  });

  final String title;
  final List<TaskListTile> taskListsTiles;
  final GroupList? group;

  @override
  State<GroupListTile> createState() => _GroupListTileState();
}

class _GroupListTileState extends State<GroupListTile> {
  bool isExpanded = false;

  void showGroupForm(ManagGroupFormType type) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            insetPadding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: ManageGroupFrom(type: type, groupList: widget.group),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      onExpansionChanged: (value) => setState(() => isExpanded = value),
      leading:
          isExpanded
              ? null
              : const Icon(
                Icons.library_books_outlined,
                color: Colors.blueGrey,
              ),
      title: Row(
        children: [
          Text(
            widget.title,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (isExpanded) ...[
            const Spacer(),
            PopupMenuButton(
              onSelected: (value) async {
                if (value == PopMenuValues.addOrRemoveTaskList.toString()) {
                  //TODO: Add or remove task list
                } else if (value == PopMenuValues.changeName.toString()) {
                  showGroupForm(ManagGroupFormType.update);
                } else if (value == PopMenuValues.unGroupLists.toString()) {
                  //TODO: Ungroup lists
                } else if (value == PopMenuValues.deleteGroup.toString()) {
                  showGroupForm(ManagGroupFormType.delete);
                }
              },
              itemBuilder: (context) {
                return <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: PopMenuValues.addOrRemoveTaskList.toString(),
                    child: ListTile(
                      leading: Icon(Icons.list_alt_outlined),
                      title: Text('Add or remove lists'),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: PopMenuValues.changeName.toString(),
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Change group name'),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: PopMenuValues.unGroupLists.toString(),
                    child: ListTile(
                      leading: Icon(Icons.line_style_sharp),
                      title: Text('Ungroup lists'),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: PopMenuValues.deleteGroup.toString(),
                    child: ListTile(
                      leading: Icon(Icons.delete_outlined),
                      title: Text('Delete group'),
                    ),
                  ),
                ];
              },
            ),
          ],
        ],
      ),
      tilePadding: EdgeInsets.symmetric(horizontal: 12),
      childrenPadding: EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.transparent,
      collapsedBackgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      children: [
        if (isExpanded && widget.taskListsTiles.isEmpty) ...[
          Center(
            child: Text(
              '✨ Tap or drag here to add lists ✨',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
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
              children: widget.taskListsTiles,
            ),
          ),
        ),
      ],
    );
  }
}
