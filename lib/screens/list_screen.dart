import 'package:blazely/models/group_list.dart';
import 'package:blazely/models/task.dart';
import 'package:blazely/models/task_list.dart';
import 'package:blazely/providers/dynamic_task_list_provider.dart';
import 'package:blazely/providers/group_list_provider.dart';
import 'package:blazely/providers/task_list_provider.dart';
import 'package:blazely/utils/snackbar_helper.dart';
import 'package:blazely/widgets/animations/blazely_loading_widget.dart';
import 'package:blazely/widgets/appbars/list_screen_appbar.dart';
import 'package:blazely/widgets/forms/add_task_form.dart';
import 'package:blazely/widgets/tiles/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({
    super.key,
    required this.defaultImageWhenEmpty,
    required this.defaultMsgWhenEmpty,
    required this.showShareTaskButton,
    this.taskList,
    this.groupList,
    this.dynamicTaskListType,
  });

  final Image defaultImageWhenEmpty;
  final String defaultMsgWhenEmpty;
  final bool showShareTaskButton;
  final TaskList? taskList;
  final GroupList? groupList;
  final DynamicTaskListType? dynamicTaskListType;

  List<Task> _getTasksByCompletionStatus(TaskList? taskList, bool isCompleted) {
    return taskList?.tasks
            ?.where((task) => task.isCompleted == isCompleted)
            .toList() ??
        [];
  }

  List<Task> getCompletedTasks(TaskList? taskList) {
    return _getTasksByCompletionStatus(taskList, true);
  }

  List<Task> getNotCompletedTasks(TaskList? taskList) {
    return _getTasksByCompletionStatus(taskList, false);
  }

  Widget notFoundOrEmptyWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          defaultImageWhenEmpty,
          const SizedBox(height: 20),
          Text(
            defaultMsgWhenEmpty,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget taskListScreenBody(
    BuildContext context,
    WidgetRef ref,
    TaskList? taskList,
  ) {
    final notCompletedTasks = getNotCompletedTasks(taskList);
    final completedTasks = getCompletedTasks(taskList);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: ListScreenAppbar(
        taskList: taskList,
        showShareTaskButton: showShareTaskButton,
      ),
      body:
          taskList?.tasks?.isEmpty ?? true
              ? notFoundOrEmptyWidget(context)
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: notCompletedTasks.length,
                          itemBuilder: (context, index) {
                            final task = notCompletedTasks[index];

                            return TaskTile(task: task)
                                .animate()
                                .fadeIn()
                                .scale(duration: 350.ms)
                                .slideY();
                          },
                        ).animate().fade().scale(begin: Offset(0.8, 0.8)),
                        SizedBox(height: 20),
                        if (completedTasks.isNotEmpty)
                          ExpansionTile(
                                initiallyExpanded: true,
                                tilePadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                backgroundColor: Colors.transparent,
                                collapsedBackgroundColor: Colors.transparent,
                                title: Text(
                                  "Completed ${completedTasks.length}",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: completedTasks.length,
                                    itemBuilder: (context, index) {
                                      final task = completedTasks[index];

                                      return TaskTile(task: task)
                                          .animate()
                                          .fadeIn()
                                          .scale(duration: 350.ms)
                                          .slideY();
                                    },
                                  ),
                                ],
                              )
                              .animate()
                              .fadeIn(duration: 200.ms)
                              .scale(duration: 350.ms)
                              .move(duration: 300.ms),
                      ],
                    )
                    .animate()
                    .fade()
                    .scale(duration: 450.ms)
                    .move(duration: 350.ms),
              ),
      floatingActionButton:
          dynamicTaskListType == null
              ? FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => Dialog(
                          insetPadding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          child: AddTaskForm(
                            taskList: this.taskList!,
                            groupList: groupList,
                          ),
                        ),
                  );
                },
              )
              : null,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskListsAsync = ref.watch(taskListAsyncProvider);
    final groupListsAsync = ref.watch(groupListAsyncProvider);
    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;

    //show snackbar error when task list state is on error
    ref.listen(taskListAsyncProvider, (previous, next) {
      if (next is AsyncError && isCurrent) {
        SnackbarHelper.showCustomSnackbar(
          context: context,
          message: "Something went wrong, please try again later.",
          type: SnackbarType.error,
        );
      }
    });

    //show snackbar error when group list state is on error
    ref.listen(groupListAsyncProvider, (previous, next) {
      if (next is AsyncError && isCurrent) {
        SnackbarHelper.showCustomSnackbar(
          context: context,
          message: "Something went wrong, please try again later.",
          type: SnackbarType.error,
        );
      }
    });

    if (taskListsAsync.isLoading || groupListsAsync.isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlazelyLoadingWidget(
          loadingText: 'Loading...',
          primaryColor: Theme.of(context).primaryColor,
          secondaryColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }

    // if task is provided in means is a dynamic task list
    // completed task list, My day task list etc...
    if (dynamicTaskListType != null) {
      final dynamicList = ref.watch(
        dynamicTaskListProvider(dynamicTaskListType!),
      );
      return taskListScreenBody(context, ref, dynamicList!);
    }

    if (groupList != null) {
      var groups = groupListsAsync.valueOrNull;
      final selectedGroup =
          groups?.where((group) => group.id == groupList?.id).firstOrNull;

      final selectedList =
          selectedGroup?.lists
              ?.where((list) => list.id == taskList?.id)
              .firstOrNull;

      return taskListScreenBody(context, ref, selectedList);
    } else {
      var lists = taskListsAsync.valueOrNull;
      final selectedList =
          lists?.where((list) => list.id == taskList?.id).firstOrNull;

      return taskListScreenBody(context, ref, selectedList);
    }
  }
}
