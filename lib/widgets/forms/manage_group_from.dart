import 'package:blazely/models/group_list.dart';
import 'package:blazely/providers/group_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ManagGroupFormType { create, update, delete }

class ManageGroupFrom extends ConsumerStatefulWidget {
  const ManageGroupFrom({
    super.key,
    required this.type,
    required this.groupList,
  });

  final ManagGroupFormType type;
  final GroupList? groupList;

  @override
  ConsumerState<ManageGroupFrom> createState() => _ManageGroupFromState();
}

class _ManageGroupFromState extends ConsumerState<ManageGroupFrom> {
  final textController = TextEditingController();

  @override
  void initState() {
    if (widget.type == ManagGroupFormType.update) {
      textController.text = widget.groupList!.name;
    }
    textController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future _createGroup(
    BuildContext context,
    GroupListAsyncNotifier groupListAsyncNotifier,
  ) async {
    if (textController.text.isNotEmpty) {
      await groupListAsyncNotifier.addGroupList(textController.text);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future _updateGroup(
    BuildContext context,
    GroupListAsyncNotifier groupListAsyncNotifier,
  ) async {
    await groupListAsyncNotifier.updateGroupList(
      widget.groupList!.copyWith(name: textController.text),
    );
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future _deleteGroup(
    BuildContext context,
    GroupListAsyncNotifier groupListAsyncNotifier,
  ) async {
    await groupListAsyncNotifier.deleteGroupList(widget.groupList!);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  bool _isDataValid(List<GroupList> groupLists) {
    final isGroupListNameUnique =
        !groupLists.any(
          (groupList) =>
              groupList.name.trim().toLowerCase() ==
              textController.text.trim().toLowerCase(),
        );

    return (textController.text.isNotEmpty &&
            (isGroupListNameUnique ||
                (widget.type == ManagGroupFormType.update &&
                    textController.text == widget.groupList!.name)) ||
        widget.type == ManagGroupFormType.delete);
  }

  String _resolveTitleText() {
    switch (widget.type) {
      case ManagGroupFormType.create:
        return "New Group";
      case ManagGroupFormType.update:
        return widget.groupList?.name ?? "Update Group";
      case ManagGroupFormType.delete:
        return widget.groupList?.name ?? "Delete Group";
    }
  }

  String _resolveActionButtonText() {
    switch (widget.type) {
      case ManagGroupFormType.create:
        return "Create";
      case ManagGroupFormType.update:
        return "Update";
      case ManagGroupFormType.delete:
        return "Delete";
    }
  }

  Color _resolveActionBackgroundButtonColor(
    bool isDarkMode,
    List<GroupList> groupLists,
  ) {
    if (!_isDataValid(groupLists)) {
      return isDarkMode ? Colors.grey.shade500 : Colors.grey.shade700;
    }

    if (widget.type == ManagGroupFormType.create) {
      // Green for create
      return isDarkMode
          ? const Color(0xFF66BB6A) // Softer green for dark theme
          : const Color(0xFF4CAF50); // Normal green for light theme
    } else {
      // Red for delete or other actions
      return isDarkMode
          ? const Color(0xFFF44336) // Normal red for light theme
          : const Color(0xFFEF5350); // Softer red for dark theme
    }
  }

  Future<void> _resolveAction(
    BuildContext context,
    GroupListAsyncNotifier groupListAsyncNotifier,
  ) async {
    if (textController.text.isNotEmpty &&
        widget.type == ManagGroupFormType.create &&
        context.mounted) {
      await _createGroup(context, groupListAsyncNotifier);
      //
    } else if (textController.text.isNotEmpty &&
        widget.type == ManagGroupFormType.update &&
        context.mounted) {
      await _updateGroup(context, groupListAsyncNotifier);
      //
    } else if (widget.type == ManagGroupFormType.delete && context.mounted) {
      await _deleteGroup(context, groupListAsyncNotifier);
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupsLists = ref.watch(groupListAsyncProvider).value;
    final groupListAsyncNotifier = ref.watch(groupListAsyncProvider.notifier);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // if user is creating a new group or updating an existing group
            if (widget.type != ManagGroupFormType.delete) ...[
              Text(
                _resolveTitleText(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: textController,
                maxLength: 100,
                decoration: const InputDecoration(
                  labelText: 'Write the group title',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  // Check for empty value
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a list name';
                  }

                  final trimmedValue = value.trim().toLowerCase();

                  // Check if name exists in any other list (excluding current list when updating)
                  final nameExists =
                      groupsLists?.any(
                        (grouplist) =>
                            grouplist.name.trim().toLowerCase() ==
                                trimmedValue &&
                            grouplist.id != widget.groupList?.id,
                      ) ??
                      false;

                  if (nameExists) {
                    return 'group name already exists';
                  }

                  return null;
                },
              ),
            ],

            // if user is deleting a group
            if (widget.type == ManagGroupFormType.delete) ...[
              Text(
                "Are you sure?",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 5),
              Text(
                "\"${widget.groupList?.name}\" will be deleted permanently.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],

            // widegts to cancel and update | delete | create
            const SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style:
                        widget.type == ManagGroupFormType.update
                            ? Theme.of(context).elevatedButtonTheme.style
                            : Theme.of(
                              context,
                            ).elevatedButtonTheme.style?.copyWith(
                              backgroundColor: WidgetStatePropertyAll(
                                _resolveActionBackgroundButtonColor(
                                  isDarkMode,
                                  groupsLists ?? [],
                                ),
                              ),
                            ),

                    onPressed:
                        _isDataValid(groupsLists ?? [])
                            ? () async {
                              await _resolveAction(
                                context,
                                groupListAsyncNotifier,
                              );
                            }
                            : null,
                    child: Text(
                      _resolveActionButtonText(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
