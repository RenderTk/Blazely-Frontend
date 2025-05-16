import 'package:blazely/models/task.dart';
import 'package:blazely/models/task_list.dart';
import 'package:blazely/providers/group_list_provider.dart';
import 'package:blazely/providers/task_list_provider.dart';
import 'package:blazely/utils/snackbar_helper.dart';
import 'package:blazely/widgets/animations/blazely_loading_widget.dart';
import 'package:blazely/widgets/appbars/list_screen_appbar.dart';
import 'package:blazely/widgets/tiles/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({
    super.key,
    required this.defaultImageWhenEmpty,
    required this.defaultMsgWhenEmpty,
    required this.showShareTaskButton,
    required this.taskListId,
    this.groupListId,
  });

  final Image defaultImageWhenEmpty;
  final String defaultMsgWhenEmpty;
  final bool showShareTaskButton;
  final int taskListId;
  final int? groupListId;

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
        title: taskList?.name ?? 'Not found',
        leadingEmoji: taskList?.emoji ?? '😣',
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
                        final taskId = notCompletedTasks[index].id ?? -1;

                        return TaskTile(
                          taskId: taskId,
                          taskListId: taskListId,
                          groupListId: groupListId,
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    if (completedTasks.isNotEmpty)
                      ExpansionTile(
                        tilePadding: EdgeInsets.symmetric(horizontal: 12),
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
                              final taskId = completedTasks[index].id ?? -1;

                              return TaskTile(
                                taskId: taskId,
                                taskListId: taskListId,
                                groupListId: groupListId,
                              );
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
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
    if (groupListId != null) {
      var groups = groupListsAsync.valueOrNull;
      final selectedGroup =
          groups?.where((group) => group.id == groupListId).firstOrNull;

      final selectedList =
          selectedGroup?.lists
              ?.where((list) => list.id == taskListId)
              .firstOrNull;

      return taskListScreenBody(context, ref, selectedList);
    } else {
      var lists = taskListsAsync.valueOrNull;
      final selectedList =
          lists?.where((list) => list.id == taskListId).firstOrNull;

      return taskListScreenBody(context, ref, selectedList);
    }

    // if (groupListId != null) {
    //   return groupListsAsync.when(
    //     data: (groups) {
    //       final selectedGroup =
    //           groups.where((group) => group.id == groupListId).firstOrNull;

    //       final selectedList =
    //           selectedGroup?.lists
    //               ?.where((list) => list.id == taskListId)
    //               .firstOrNull;

    //       return taskListScreenBody(context, ref, selectedList);
    //     },
    //     loading: () => const CircularProgressIndicator(),
    //     error: (e, st) => const SizedBox(),
    //   );
    // } else {
    //   return taskListsAsync.when(
    //     data: (lists) {
    //       final selectedList =
    //           lists.where((list) => list.id == taskListId).firstOrNull;

    //       return taskListScreenBody(context, ref, selectedList);
    //     },
    //     loading: () => const CircularProgressIndicator(),
    //     error: (e, st) => const SizedBox(),
    //   );
    // }
  }
}
