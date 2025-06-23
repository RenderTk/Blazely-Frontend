import 'package:blazely/models/task_list.dart';
import 'package:blazely/providers/models_providers/dynamic_task_list_provider.dart';
import 'package:blazely/providers/ui_providers/selected_tasks_provider.dart';
import 'package:blazely/providers/ui_providers/task_selection_mode_provider.dart';
import 'package:blazely/widgets/forms/manage_list_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

enum PopMenuValuesOnTaskSelectionIsOff {
  changeName,
  sendCopy,
  duplicate,
  print,
  delete,
}

enum PopMenuValuesOnTaskSelectionIsOn {
  selectAll,
  unselectAll,
  move,
  copy,
  delete,
}

class ListScreenAppbar extends ConsumerWidget implements PreferredSizeWidget {
  const ListScreenAppbar({
    super.key,
    required this.taskList,
    this.showShareTaskButton = false,
    this.dynamicTaskListType,
  });

  final TaskList? taskList;
  final bool showShareTaskButton;
  final DynamicTaskListType? dynamicTaskListType;

  bool get isDynamicTaskList => dynamicTaskListType != null;

  Future showManageListDialog(
    BuildContext context,
    ManageListFormType type,
  ) async {
    var isDeleted = await showDialog<bool>(
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

    if (context.mounted && isDeleted == true) {
      Navigator.pop(context);
    }
  }

  String _getListFormattedAsString() {
    final buffer = StringBuffer();
    buffer.writeln("${taskList?.emoji} ${taskList?.name}");
    buffer.writeln();

    if (taskList?.tasks != null) {
      for (var task in taskList!.tasks!) {
        if (task.isCompleted) {
          buffer.write("✅ ");
        } else {
          buffer.write("❌ ");
        }
        buffer.write(task.text);
        if (task.isImportant) {
          buffer.write(" ⭐");
        }
        buffer.writeln();
      }
    }
    return buffer.toString();
  }

  Future shareText() async {
    await SharePlus.instance.share(
      ShareParams(text: _getListFormattedAsString()),
    );
  }

  Widget _buildAppbarOnTaskSelectionIsOff(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        children: [
          Text(
            taskList?.emoji ?? '😣',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(width: 10),

          Flexible(
            child: Text(
              taskList?.name ?? "Error fetching list name",
              style: Theme.of(context).textTheme.titleMedium,
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
          onSelected: (value) async {
            if (value ==
                PopMenuValuesOnTaskSelectionIsOff.changeName.toString()) {
              await showManageListDialog(context, ManageListFormType.update);
            } else if (value ==
                PopMenuValuesOnTaskSelectionIsOff.sendCopy.toString()) {
              await shareText();
            } else if (value ==
                PopMenuValuesOnTaskSelectionIsOff.duplicate.toString()) {
              //TODO: Duplicate list
            } else if (value ==
                PopMenuValuesOnTaskSelectionIsOff.print.toString()) {
              //TODO: Print list
            } else if (value ==
                PopMenuValuesOnTaskSelectionIsOff.delete.toString()) {
              await showManageListDialog(context, ManageListFormType.delete);
            }
          },

          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          position: PopupMenuPosition.under,
          itemBuilder: (context) {
            if (taskList == null) return [];
            return <PopupMenuEntry<String>>[
              //not available for dynamic tasklists
              if (!isDynamicTaskList)
                PopupMenuItem<String>(
                  value:
                      PopMenuValuesOnTaskSelectionIsOff.changeName.toString(),
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text('Change list name'),
                  ),
                ),
              PopupMenuItem<String>(
                value: PopMenuValuesOnTaskSelectionIsOff.sendCopy.toString(),
                child: ListTile(
                  leading: Icon(Icons.share_outlined),
                  title: Text('Share copy'),
                ),
              ),
              //not available for dynamic tasklists
              if (!isDynamicTaskList)
                PopupMenuItem<String>(
                  value: PopMenuValuesOnTaskSelectionIsOff.duplicate.toString(),
                  child: ListTile(
                    leading: Icon(Icons.copy_outlined),
                    title: Text('Duplicate list'),
                  ),
                ),
              PopupMenuItem<String>(
                value: PopMenuValuesOnTaskSelectionIsOff.print.toString(),
                child: ListTile(
                  leading: Icon(Icons.print_outlined),
                  title: Text('Print list'),
                ),
              ),
              //not available for dynamic tasklists
              if (!isDynamicTaskList)
                PopupMenuItem<String>(
                  value: PopMenuValuesOnTaskSelectionIsOff.delete.toString(),
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

  Widget _buildAppBarOnTaskSelectionIsOn(BuildContext context, WidgetRef ref) {
    final selectedTasks = ref.watch(selectedTasksProvider);
    final taskSelectionModeNotifier = ref.watch(
      taskSelectionModeProvider.notifier,
    );
    final selectedTasksNotifier = ref.watch(selectedTasksProvider.notifier);

    bool areAllTasksSelected = selectedTasks.length == taskList?.tasks?.length;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Row(
        children: [
          IconButton(
            onPressed: () {
              selectedTasksNotifier.clear();
              taskSelectionModeNotifier.disable();
            },
            icon: const Icon(Icons.cancel_outlined),
          ),
          SizedBox(width: 10),
          Text("${selectedTasks.length}"),
        ],
      ),
      actions: [
        if (dynamicTaskListType != DynamicTaskListType.myDay)
          IconButton(icon: const Icon(Icons.sunny), onPressed: () {}),

        if (dynamicTaskListType != DynamicTaskListType.planned)
          IconButton(icon: const Icon(Icons.calendar_today), onPressed: () {}),

        PopupMenuButton(
          itemBuilder: (context) {
            return [
              if (areAllTasksSelected)
                const PopupMenuItem(
                  value: PopMenuValuesOnTaskSelectionIsOn.unselectAll,
                  child: ListTile(
                    leading: Icon(Icons.remove_circle_outlined),
                    title: Text("Unselect all"),
                  ),
                ),
              if (!areAllTasksSelected)
                const PopupMenuItem(
                  value: PopMenuValuesOnTaskSelectionIsOn.selectAll,
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outlined),
                    title: Text("Select all"),
                  ),
                ),

              //not available for dynamic tasklists
              if (!isDynamicTaskList)
                const PopupMenuItem(
                  value: PopMenuValuesOnTaskSelectionIsOn.move,
                  child: ListTile(
                    leading: Icon(Icons.move_up_outlined),
                    title: Text("Move"),
                  ),
                ),

              //not available for dynamic tasklists
              if (!isDynamicTaskList)
                const PopupMenuItem(
                  value: PopMenuValuesOnTaskSelectionIsOn.copy,
                  child: ListTile(
                    leading: Icon(Icons.copy_outlined),
                    title: Text("Copy"),
                  ),
                ),
              const PopupMenuItem(
                value: PopMenuValuesOnTaskSelectionIsOn.delete,
                child: ListTile(
                  leading: Icon(Icons.delete_outlined),
                  title: Text("Delete"),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskTileSelectionModeIsOn = ref.watch(taskSelectionModeProvider);

    return taskTileSelectionModeIsOn
        ? _buildAppBarOnTaskSelectionIsOn(context, ref)
        : _buildAppbarOnTaskSelectionIsOff(context);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
