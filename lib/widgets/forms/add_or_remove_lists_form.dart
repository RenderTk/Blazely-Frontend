import 'package:blazely/models/group_list.dart';
import 'package:blazely/models/task_list.dart';
import 'package:blazely/providers/group_list_provider.dart';
import 'package:blazely/providers/task_list_provider.dart';
import 'package:blazely/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddOrRemoveListsForm extends ConsumerStatefulWidget {
  const AddOrRemoveListsForm({super.key, required this.groupList});

  final GroupList groupList;

  @override
  ConsumerState<AddOrRemoveListsForm> createState() =>
      AddOrRemoveListsFormState();
}

class AddOrRemoveListsFormState extends ConsumerState<AddOrRemoveListsForm> {
  late final GroupList groupList;
  late final List<GroupList>? groupLists;
  late final List<TaskList>? tasklists;
  late final List<TaskList> tasksListsInGroup;
  late final List<TaskList> allTaskLists;
  late final List<TaskList> initalStateOfAlltaskLists;
  bool changesDetected = false;

  @override
  void initState() {
    super.initState();
    groupLists = ref.read(groupListAsyncProvider).valueOrNull;
    groupList =
        groupLists?.where((group) => group.id == widget.groupList.id).first ??
        GroupList(id: -1, name: "Grupo desconocido", lists: []);

    tasklists = ref.read(taskListAsyncProvider).valueOrNull;
    tasksListsInGroup = groupList.lists ?? [];
    allTaskLists = [...tasklists!, ...tasksListsInGroup];
    initalStateOfAlltaskLists = allTaskLists.map((e) => e.copyWith()).toList();
  }

  void _sortByName(List<TaskList> list) {
    list.sort((a, b) => a.name.compareTo(b.name));
  }

  void _sortById(List<TaskList> list) {
    list.sort((a, b) => a.id!.compareTo(b.id!));
  }

  bool _hasChanges() {
    if (allTaskLists.length != initalStateOfAlltaskLists.length) return true;

    _sortById(allTaskLists);
    _sortById(initalStateOfAlltaskLists);

    for (int i = 0; i < allTaskLists.length; i++) {
      if (allTaskLists[i].group != initalStateOfAlltaskLists[i].group) {
        return true;
      }
    }
    return false;
  }

  Future onSave(GroupListAsyncNotifier groupListAsyncNotifier) async {
    _sortById(allTaskLists);
    _sortById(initalStateOfAlltaskLists);

    List<TaskList> taskListToRemoveFromGroup = [];
    List<TaskList> taskListToAddFromGroup = [];

    for (int i = 0; i < allTaskLists.length; i++) {
      if (allTaskLists[i].group != initalStateOfAlltaskLists[i].group) {
        if (allTaskLists[i].group == null) {
          taskListToRemoveFromGroup.add(allTaskLists[i]);
        } else {
          taskListToAddFromGroup.add(allTaskLists[i]);
        }
      }
    }

    if (taskListToRemoveFromGroup.isNotEmpty) {
      await groupListAsyncNotifier.unGroupTaskList(
        groupList,
        taskListToRemoveFromGroup,
      );
    }

    if (taskListToAddFromGroup.isNotEmpty) {
      await groupListAsyncNotifier.groupTaskLists(
        groupList,
        taskListToAddFromGroup,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupListAsyncNotifier = ref.read(groupListAsyncProvider.notifier);
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    _sortByName(allTaskLists);

    if (allTaskLists.isEmpty) {
      Navigator.pop(context);
    }

    ref.listen(groupListAsyncProvider, (previous, next) {
      if (next is AsyncError && isCurrent) {
        SnackbarHelper.showCustomSnackbar(
          context: context,
          message:
              "Something went wrong updating the tasklists in the group. Please try again later.",
          type: SnackbarType.error,
        );
      }
    });

    Future<void> resolveAction(TaskList taskList) async {
      if (taskList.group == null) {
        //
        taskList.group = groupList.id;
        //
      } else {
        //
        taskList.group = null;
        //
      }
    }

    return Card(
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add or remove Lists from ${groupList.name}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(thickness: 2),
            SizedBox(height: 15),
            SizedBox(
              height: 400,
              width: double.infinity,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: allTaskLists.length,
                itemBuilder:
                    (context, index) => Card(
                      margin: const EdgeInsets.all(5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Text(
                              allTaskLists[index].emoji,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              allTaskLists[index].name,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Spacer(),
                            allTaskLists[index].group != null
                                ? IconButton(
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    await resolveAction(allTaskLists[index]);
                                    setState(() {
                                      changesDetected = _hasChanges();
                                    });
                                  },
                                )
                                : IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.green,
                                  ),
                                  onPressed: () async {
                                    await resolveAction(allTaskLists[index]);
                                    setState(() {
                                      changesDetected = _hasChanges();
                                    });
                                  },
                                ),
                          ],
                        ),
                      ),
                    ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed:
                      changesDetected
                          ? () async {
                            await onSave(groupListAsyncNotifier);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                          : null,
                  child: const Text("Save"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
