import 'package:blazely/models/group_list.dart';
import 'package:blazely/models/task_list.dart';
import 'package:blazely/providers/group_list_provider.dart';
import 'package:blazely/providers/task_list_provider.dart';
import 'package:blazely/utils/snackbar_helper.dart';
import 'package:blazely/widgets/pickers/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/web.dart';

enum ManageListFormType { create, update, delete }

class ManageListForm extends ConsumerStatefulWidget {
  const ManageListForm({super.key, required this.type, required this.taskList});

  final ManageListFormType type;
  final TaskList? taskList;

  @override
  ConsumerState<ManageListForm> createState() => _ManageListFormState();
}

class _ManageListFormState extends ConsumerState<ManageListForm> {
  bool _showEmojiPicker = false;
  TextEditingController textController = TextEditingController();
  TextEditingController emojiController = TextEditingController();
  String? previousEmoji;

  final errorMsgMap = {
    ManageListFormType.create: "creating",
    ManageListFormType.update: "updating",
    ManageListFormType.delete: "deleting",
  };

  @override
  void initState() {
    super.initState();
    if (widget.type == ManageListFormType.update) {
      previousEmoji = widget.taskList!.emoji;
      emojiController.text = widget.taskList!.emoji;
      textController.text = widget.taskList!.name;
    }
    textController.addListener(() {
      setState(() {});
    });
    emojiController.addListener(() {
      setState(() {
        _showEmojiPicker = !_showEmojiPicker;
      });
    });
  }

  @override
  void dispose() {
    textController.dispose();
    emojiController.dispose();
    super.dispose();
  }

  Future<void> _createList(
    BuildContext context,
    TaskListAsyncNotifier taskListAsyncNotifier,
  ) async {
    if (textController.text.isNotEmpty && emojiController.text.isNotEmpty) {
      //
      final createdTaskList = await taskListAsyncNotifier.addTaskList(
        textController.text,
        emojiController.text,
      );
      if (context.mounted && createdTaskList != null) {
        Navigator.pop<TaskList>(context, createdTaskList);
      }
    }
  }

  Future<void> _updateList(
    BuildContext context,
    TaskListAsyncNotifier taskListAsyncNotifier,
    GroupListAsyncNotifier groupListAsyncNotifier,
  ) async {
    //
    // if the list has a group it is owned by the group list provider
    if (widget.taskList?.group != null) {
      await groupListAsyncNotifier.updateTaskListInGroup(
        widget.taskList!.copyWith(
          name: textController.text,
          emoji: emojiController.text,
        ),
      );
    }
    else{
       //if the list has no group it is own by the task list provider
      await taskListAsyncNotifier.updateTaskList(
        widget.taskList!.copyWith(
          name: textController.text,
          emoji: emojiController.text,
        ),
      );
    }
   

    if (context.mounted) {
      Navigator.pop<bool>(context, false);
    }
  }

  Future<void> _deleteList(
    BuildContext context,
    TaskListAsyncNotifier taskListAsyncNotifier,
    GroupListAsyncNotifier groupListAsyncNotifier,
  ) async {
    // if the list has a group it is owned by the group list provider
    if (widget.taskList?.group != null) {
      //
      await groupListAsyncNotifier.deleteTasklistInGroup(widget.taskList!);
      //
    } else {
      //if the list has no group it is own by the task list provider
      await taskListAsyncNotifier.deleteTaskList(widget.taskList!);
      //
    }
    if (context.mounted) {
      Navigator.pop<bool>(context, true);
    }
  }

  String _resolveTitleText() {
    switch (widget.type) {
      case ManageListFormType.create:
        return "New List";
      case ManageListFormType.update:
        return "Update List";
      case ManageListFormType.delete:
        return "Delete ${widget.taskList?.name} ?";
    }
  }

  String _resolveActionButtonText() {
    switch (widget.type) {
      case ManageListFormType.create:
        return "Create";
      case ManageListFormType.update:
        return 'Update';
      case ManageListFormType.delete:
        return "Delete";
    }
  }

  Future<void> _resolveAction(
    BuildContext context,
    TaskListAsyncNotifier taskListAsyncNotifier,
    GroupListAsyncNotifier groupListAsyncNotifier,
  ) async {
    if (textController.text.isNotEmpty &&
        emojiController.text.isNotEmpty &&
        widget.type == ManageListFormType.create &&
        context.mounted) {
      await _createList(context, taskListAsyncNotifier);
      //
    } else if (textController.text.isNotEmpty &&
        emojiController.text.isNotEmpty &&
        widget.type == ManageListFormType.update &&
        context.mounted) {
      await _updateList(context, taskListAsyncNotifier, groupListAsyncNotifier);
      //
    } else if (widget.type == ManageListFormType.delete && context.mounted) {
      await _deleteList(context, taskListAsyncNotifier, groupListAsyncNotifier);
    }
  }

  Color _resolveActionBackgroundButtonColor(
    bool isDarkMode,
    List<TaskList> taskLists,
    List<GroupList> groupsLists,
  ) {
    if (widget.type == ManageListFormType.create) {
      if (!_isDataValid(taskLists, groupsLists)) {
        return isDarkMode ? Colors.grey.shade500 : Colors.grey.shade700;
      }

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

  bool _isDataValid(List<TaskList> taskLists, List<GroupList> groupsLists) {
    final trimmedInputName = textController.text.trim().toLowerCase();
    final allLists = [
      ...taskLists,
      ...groupsLists.expand((groupList) => groupList.lists!),
    ];

    final isTaskListNameUnique =
        !allLists.any(
          (taskList) => taskList.name.trim().toLowerCase() == trimmedInputName,
        );

    bool isTextNotEmpty = textController.text.isNotEmpty;
    bool isNameValid =
        widget.type == ManageListFormType.update
            ? previousEmoji != emojiController.text || isTaskListNameUnique
            : isTaskListNameUnique;

    bool isDeleteOperation = widget.type == ManageListFormType.delete;
    bool isEmojiNotEmpty = emojiController.text.isNotEmpty;

    return isTextNotEmpty && isNameValid && isEmojiNotEmpty ||
        isDeleteOperation;
  }

  String? _validateInput(
    List<TaskList> taskLists,
    List<GroupList> groupsLists,
    String? value,
  ) {
    bool isDeleteOperation = widget.type == ManageListFormType.delete;
    // Skip validation for delete operation
    if (isDeleteOperation) {
      return null;
    }

    // Check for empty value
    if (value?.trim().isEmpty ?? true) {
      return 'Please enter a list name';
    }

    final trimmedValue = value?.trim().toLowerCase();

    // Check if name exists in any other list (excluding current list when updating)

    final allLists = [
      ...taskLists,
      ...groupsLists.expand((groupList) => groupList.lists!),
    ];
    final nameExists = allLists.any(
      (taskList) => taskList.name.trim().toLowerCase() == trimmedValue,
    );

    if (nameExists) {
      return 'List name already exists';
    }

    final isEmojiEmpty = emojiController.text.isEmpty;

    if (isEmojiEmpty) {
      return 'Please choose an emoji';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final taskListAsyncNotifier = ref.read(taskListAsyncProvider.notifier);
    final groupListAsyncNotifier = ref.read(groupListAsyncProvider.notifier);
    final taskLists = ref.read(taskListAsyncProvider).value;
    final groupsLists = ref.read(groupListAsyncProvider).value;
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    ref.listen(taskListAsyncProvider, (previous, next) {
      if (next is AsyncError && isCurrent) {
        SnackbarHelper.showCustomSnackbar(
          context: context,
          message:
              "Something went wrong ${errorMsgMap[widget.type]} the list. Please try again later.",
          type: SnackbarType.error,
        );
        Logger().e(next.error, stackTrace: next.stackTrace);
      }
    });

    ref.listen(groupListAsyncProvider, (previous, next) {
      if (next is AsyncError && isCurrent) {
        SnackbarHelper.showCustomSnackbar(
          context: context,
          message:
              "Something went wrong ${errorMsgMap[widget.type]} the list. Please try again later.",
          type: SnackbarType.error,
        );
        Logger().e(next.error, stackTrace: next.stackTrace);
      }
    });

    return Card(
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.type != ManageListFormType.delete) ...[
              Row(
                children: [
                  // widget to show when creating a new list or updating an existing one
                  Text(
                    _resolveTitleText(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop<bool>(context, false),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showEmojiPicker = !_showEmojiPicker;
                      });
                    },
                    // Emoji picker icon //
                    icon:
                        emojiController.text.isEmpty
                            ? const Icon(Icons.emoji_emotions, size: 30)
                            : Text(
                              emojiController.text.isEmpty
                                  ? widget.taskList!.emoji
                                  : emojiController.text,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Write the list title',
                      ),
                      controller: textController,
                      maxLength: 100,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator:
                          (value) => _validateInput(
                            taskLists ?? [],
                            groupsLists ?? [],
                            value!,
                          ),
                    ),
                  ),
                ],
              ),
            ],

            // widget to show when deleting a list
            if (widget.type == ManageListFormType.delete) ...[
              Text(
                "Are you sure?",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 5),
              Text(
                "\"${widget.taskList?.name}\" will be deleted permanently.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            // show emoji picker when showEmojiPicker is true
            if (_showEmojiPicker) ...[
              SizedBox(height: 20),
              Flexible(child: EmojiPicker(emojiController: emojiController)),
            ],

            // If the emoji picker is not shown show the buttons to create the list
            if (!_showEmojiPicker) ...[
              SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop<bool>(context, false),
                      child: Text(
                        'Cancel',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      style:
                          widget.type == ManageListFormType.update
                              ? Theme.of(context).elevatedButtonTheme.style
                              : Theme.of(
                                context,
                              ).elevatedButtonTheme.style?.copyWith(
                                backgroundColor: WidgetStatePropertyAll(
                                  _resolveActionBackgroundButtonColor(
                                    isDarkMode,
                                    taskLists ?? [],
                                    groupsLists ?? [],
                                  ),
                                ),
                              ),
                      onPressed:
                          _isDataValid(taskLists ?? [], groupsLists ?? [])
                              ? () async {
                                await _resolveAction(
                                  context,
                                  taskListAsyncNotifier,
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
          ],
        ),
      ),
    );
  }
}
