import 'package:blazely/models/task_list.dart';
import 'package:blazely/widgets/forms/manage_list_form.dart';
import 'package:flutter/material.dart';

enum PopMenuValues { changeName, sendCopy, duplicate, print, delete }

class ListScreenAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ListScreenAppbar({
    super.key,
    required this.taskList,
    this.showShareTaskButton = false,
  });

  final TaskList? taskList;
  final bool showShareTaskButton;

  @override
  Widget build(BuildContext context) {
    void showManageListDialog(BuildContext context, ManageListFormType type) {
      showDialog(
        context: context,
        builder:
            (context) => Dialog(
              insetPadding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: ManageListForm(type: type, taskList: taskList),
            ),
      );
    }

    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        children: [
          if (taskList?.emoji != null) ...[
            Text(
              taskList?.emoji ?? '😣',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Text(
              taskList?.name ?? "Couldn't load task list",
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
        PopupMenuButton(
          onSelected: (value) {
            if (value == PopMenuValues.changeName.toString()) {
              showManageListDialog(context, ManageListFormType.update);
            } else if (value == PopMenuValues.sendCopy.toString()) {
              //TODO: Share copy of list
            } else if (value == PopMenuValues.duplicate.toString()) {
              //TODO: Duplicate list
            } else if (value == PopMenuValues.print.toString()) {
              //TODO: Print list
            } else if (value == PopMenuValues.delete.toString()) {
              showManageListDialog(context, ManageListFormType.delete);
            }
          },

          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          position: PopupMenuPosition.under,
          itemBuilder: (context) {
            return <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: PopMenuValues.changeName.toString(),
                child: ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text('Change list name'),
                ),
              ),
              PopupMenuItem<String>(
                value: PopMenuValues.sendCopy.toString(),
                child: ListTile(
                  leading: Icon(Icons.share_outlined),
                  title: Text('Share copy'),
                ),
              ),
              PopupMenuItem<String>(
                value: PopMenuValues.duplicate.toString(),
                child: ListTile(
                  leading: Icon(Icons.copy_outlined),
                  title: Text('Duplicate list'),
                ),
              ),
              PopupMenuItem<String>(
                value: PopMenuValues.print.toString(),
                child: ListTile(
                  leading: Icon(Icons.print_outlined),
                  title: Text('Print list'),
                ),
              ),
              PopupMenuItem<String>(
                value: PopMenuValues.delete.toString(),
                child: ListTile(
                  leading: Icon(Icons.delete_outlined),
                  title: Text('Delete list'),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
