import 'package:blazely/models/group_list.dart';
import 'package:blazely/providers/group_list_provider.dart';
import 'package:blazely/widgets/forms/add_or_remove_lists_form.dart';
import 'package:blazely/widgets/forms/manage_group_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



enum PopMenuValues {
  addOrRemoveTaskList,
  changeName,
  unGroupLists,
  deleteGroup,
}

class GroupListActionMenu extends ConsumerStatefulWidget {
  const GroupListActionMenu({super.key, required this.grouplist});

  final GroupList? grouplist;

  @override
  ConsumerState<GroupListActionMenu> createState() => _GroupListTileState();
}

class _GroupListTileState extends ConsumerState<GroupListActionMenu> {
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
            child: ManageGroupFrom(type: type, groupList: widget.grouplist),
          ),
    );
  }

  void showAddOrRemoveListsForm(GroupList groupList) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            insetPadding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: AddOrRemoveListsForm(groupList: groupList),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupListAsyncNotifier = ref.watch(groupListAsyncProvider.notifier);

    return PopupMenuButton(
      onSelected: (value) async {
        if (value == PopMenuValues.addOrRemoveTaskList.toString()) {
          ///
          showAddOrRemoveListsForm(widget.grouplist!);
          //
        } else if (value == PopMenuValues.changeName.toString()) {
          ///
          showGroupForm(ManagGroupFormType.update);

          ///
        } else if (value == PopMenuValues.unGroupLists.toString()) {
          ///
          if (widget.grouplist == null) return;
          await groupListAsyncNotifier.unGroupTaskList(
            widget.grouplist!,
            widget.grouplist!.lists!.map((l) {
              l.group = null;
              return l;
            }).toList(),
          );

          ///
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
          if ((widget.grouplist?.lists?.isNotEmpty ?? false))
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
    );
  }
}
