import 'package:blazely/models/group_list.dart';
import 'package:blazely/models/task.dart';
import 'package:blazely/models/task_list.dart';
import 'package:blazely/providers/group_list_provider.dart';
import 'package:blazely/providers/task_list_provider.dart';
import 'package:blazely/utils/date_time_parsers.dart';
import 'package:blazely/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTaskForm extends ConsumerStatefulWidget {
  const AddTaskForm({super.key, required this.taskList, this.groupList});

  final GroupList? groupList;
  final TaskList taskList;

  @override
  ConsumerState<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends ConsumerState<AddTaskForm> {
  final formKey = GlobalKey<FormState>();
  final taskNameController = TextEditingController();
  final dueDateController = TextEditingController();
  final reminderDateController = TextEditingController();
  bool isImportant = false;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    // Listen to focus changes
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    taskNameController.dispose();
    dueDateController.dispose();
    reminderDateController.dispose();
    super.dispose();
  }

  String? _validateTaskdescription(String? value) {
    final trimmed = value?.trim();

    if (trimmed == null || trimmed.isEmpty) {
      return 'Please enter a valid description';
    }

    if (trimmed.length < 2) {
      return 'Description must be at least 2 characters long';
    }

    if (trimmed.length > 50) {
      return 'Description must be less than 50 characters';
    }

    if (RegExp(r'\s{2,}').hasMatch(trimmed)) {
      return 'Avoid using multiple spaces';
    }

    return null;
  }

  void clearForm() {
    taskNameController.clear();
    dueDateController.clear();
    reminderDateController.clear();
    isImportant = false;
  }

  Future _createTask(
    GroupListAsyncNotifier groupListAsyncNotifier,
    TaskListAsyncNotifier taskListAsyncNotifier,
  ) async {
    Task task = Task.empty().copyWith(
      text: taskNameController.text,
      dueDate: DateTime.tryParse(dueDateController.text),
      reminderDate: DateTime.tryParse(reminderDateController.text),
      isImportant: isImportant,
    );

    // it means the task is getting created in a list with no group
    if (widget.groupList == null) {
      await taskListAsyncNotifier.addTask(widget.taskList, task);
      return;
    }

    await groupListAsyncNotifier.addTask(
      widget.groupList!,
      widget.taskList,
      task,
    );
  }

  Widget _buildTextFormField({
    required String hintText,
    required bool showSuffixIcon,
    required bool pickOnlyDate,
    required bool isReadOnly,
    required bool hideHintOnFocus,
    required FocusNode? focusNode,
    required TextEditingController controller,
    required Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      focusNode: focusNode,
      decoration: InputDecoration(
        suffixIcon:
            showSuffixIcon
                ? IconButton(
                  onPressed: () async {
                    final dateTime = await _pickDateTime(context, pickOnlyDate);

                    if (dateTime == null) return;

                    final dateFormat =
                        pickOnlyDate
                            ? userFriendlyDateFormat
                            : userFriendlyDateTimeFormat;

                    controller.text = dateFormat.format(dateTime);
                  },
                  icon: Icon(Icons.calendar_month),
                )
                : null,
        hint:
            (hideHintOnFocus && _isFocused)
                ? null
                : Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.grey,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      hintText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.all(10),
      ),
      validator: validator != null ? (value) => validator(value) : null,
    );
  }

  Future<DateTime?> _pickDateTime(
    BuildContext context,
    bool pickOnlyDate,
  ) async {
    // Pick the date
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return null;

    if (pickOnlyDate) return date;

    // Pick the time
    TimeOfDay? time;
    if (context.mounted) {
      time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
    }

    if (time == null) return null;

    // Combine date and time into a DateTime object
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    final groupListAsyncNotifier = ref.watch(groupListAsyncProvider.notifier);
    final taskListAsyncNotifier = ref.watch(taskListAsyncProvider.notifier);
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;

    ref.listen(groupListAsyncProvider, (previous, next) {
      if (next is AsyncError && isCurrent) {
        Navigator.pop(context);
        SnackbarHelper.showCustomSnackbar(
          context: context,
          message: "Something went wrong, please try again later.",
          type: SnackbarType.error,
        );
      }
    });

    ref.listen(taskListAsyncProvider, (previous, next) {
      if (next is AsyncError && isCurrent) {
        Navigator.pop(context);
        SnackbarHelper.showCustomSnackbar(
          context: context,
          message: "Something went wrong, please try again later.",
          type: SnackbarType.error,
        );
      }
    });

    return Card(
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "Create New Task",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(thickness: 0.3, color: Colors.grey.shade400),
                SizedBox(height: 15),
                Text(
                  "Task description",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 5),
                _buildTextFormField(
                  hintText: "Enter a description for this task..",
                  showSuffixIcon: false,
                  pickOnlyDate: false,
                  isReadOnly: false,
                  hideHintOnFocus: true,
                  focusNode: _focusNode,
                  controller: taskNameController,
                  validator: _validateTaskdescription,
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 20),
                    const SizedBox(width: 5),
                    Text(
                      "Due Date",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                _buildTextFormField(
                  hintText: "Choose due date..",
                  showSuffixIcon: true,
                  pickOnlyDate: true,
                  isReadOnly: true,
                  hideHintOnFocus: false,
                  focusNode: null,
                  controller: dueDateController,
                  validator: null,
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Icon(Icons.notifications_outlined, size: 20),
                    const SizedBox(width: 5),
                    Text(
                      "Reminder Date",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                _buildTextFormField(
                  hintText: "Choose reminder date..",
                  showSuffixIcon: true,
                  pickOnlyDate: false,
                  isReadOnly: true,
                  hideHintOnFocus: false,
                  focusNode: null,
                  controller: reminderDateController,
                  validator: null,
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.grey.shade400, width: 1),
                      ),
                      margin: EdgeInsets.zero,
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isImportant = !isImportant;
                                });
                              },
                              icon:
                                  isImportant
                                      ? Icon(Icons.star, color: Colors.yellow)
                                      : Icon(Icons.star_border),
                            ),
                            Text(
                              "Mark as Important",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Spacer(),
                    ElevatedButton(onPressed: clearForm, child: Text("Clear")),
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: Theme.of(
                          context,
                        ).elevatedButtonTheme.style?.copyWith(
                          backgroundColor: WidgetStatePropertyAll(Colors.red),
                        ),
                        child: Text("Cancel"),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await _createTask(
                              groupListAsyncNotifier,
                              taskListAsyncNotifier,
                            );
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                        style: Theme.of(
                          context,
                        ).elevatedButtonTheme.style?.copyWith(
                          backgroundColor: WidgetStatePropertyAll(Colors.green),
                        ),
                        child: Text("Create Task"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
