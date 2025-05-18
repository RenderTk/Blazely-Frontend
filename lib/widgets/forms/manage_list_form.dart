import 'package:blazely/models/task_list.dart';
import 'package:blazely/providers/task_list_provider.dart';
import 'package:blazely/screens/list_screen.dart';
import 'package:blazely/utils/snackbar_helper.dart';
import 'package:blazely/widgets/pickers/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final errorMsgMap = {
    ManageListFormType.create: "creating",
    ManageListFormType.update: "updating",
    ManageListFormType.delete: "deleting",
  };

  @override
  void initState() {
    super.initState();
    if (widget.type == ManageListFormType.update) {
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ListScreen(
                  defaultImageWhenEmpty: Image.asset(
                    "assets/images/empty_tasks_custom_list.png",
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  defaultMsgWhenEmpty: "Press the + button to add tasks.",
                  showShareTaskButton: true,
                  taskListId: createdTaskList.id ?? -1,
                ),
          ),
        );
      }
    }
  }

  Future<void> _updateList(
    BuildContext context,
    TaskListAsyncNotifier taskListAsyncNotifier,
  ) async {
    await taskListAsyncNotifier.updateTaskList(
      widget.taskList!.copyWith(
        name: textController.text,
        emoji: emojiController.text,
      ),
    );
  }

  Future<void> _deleteList(
    BuildContext context,
    TaskListAsyncNotifier taskListAsyncNotifier,
  ) async {
    await taskListAsyncNotifier.deleteTaskList(widget.taskList!);
    if (context.mounted) {
      Navigator.pop(context);
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
      await _updateList(context, taskListAsyncNotifier);
      //
    } else if (widget.type == ManageListFormType.delete && context.mounted) {
      await _deleteList(context, taskListAsyncNotifier);
    }
  }

  Color _resolveActionBackgroundButtonColor(
    bool isDarkMode,
    List<TaskList> taskLists,
  ) {
    if (widget.type == ManageListFormType.create) {
      if (!_isDataValid(taskLists)) {
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

  bool _isDataValid(List<TaskList> taskLists) {
    final isTaskListNameUnique =
        !taskLists.any(
          (taskList) =>
              taskList.name.trim().toLowerCase() ==
              textController.text.trim().toLowerCase(),
        );

    return (textController.text.isNotEmpty &&
            emojiController.text.isNotEmpty &&
            (isTaskListNameUnique ||
                (widget.type == ManageListFormType.update &&
                    textController.text == widget.taskList!.name)) ||
        widget.type == ManageListFormType.delete);
  }

  @override
  Widget build(BuildContext context) {
    final taskListAsyncNotifier = ref.watch(taskListAsyncProvider.notifier);
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
    final taskLists = ref.read(taskListAsyncProvider).value;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    ref.listen(taskListAsyncProvider, (previous, next) {
      Navigator.pop(context);
      if (next is AsyncError && isCurrent) {
        SnackbarHelper.showCustomSnackbar(
          context: context,
          message:
              "Something went wrong ${errorMsgMap[widget.type]} the list. Please try again later.",
          type: SnackbarType.error,
        );
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
                    onPressed: () => Navigator.pop(context),
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
                        emojiController.text.isEmpty &&
                                widget.taskList?.emoji == null
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
                      validator: (value) {
                        // Check for empty value
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a list name';
                        }

                        final trimmedValue = value.trim().toLowerCase();

                        // Check if name exists in any other list (excluding current list when updating)
                        final nameExists =
                            taskLists?.any(
                              (taskList) =>
                                  taskList.name.trim().toLowerCase() ==
                                      trimmedValue.toLowerCase() &&
                                  taskList.id != widget.taskList?.id,
                            ) ??
                            false;

                        if (nameExists) {
                          return 'List name already exists';
                        }

                        return null;
                      },
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
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: EmojiPicker(emojiController: emojiController),
              ),
            ],

            // If the emoji picker is not shown show the buttons to create the list
            if (!_showEmojiPicker) ...[
              SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
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
                                  ),
                                ),
                              ),
                      onPressed:
                          _isDataValid(taskLists ?? [])
                              ? () async {
                                await _resolveAction(
                                  context,
                                  taskListAsyncNotifier,
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
