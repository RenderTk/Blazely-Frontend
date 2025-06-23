import 'package:blazely/models/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedTasksNotifier extends Notifier<List<Task>> {
  @override
  List<Task> build() {
    return [];
  }

  void add(Task task) {
    if (state.any((t) => t.id == task.id)) return;

    state = [...state, task];
  }

  void remove(Task task) {
    if (!state.any((t) => t.id == task.id)) return;

    state = state.where((t) => t.id != task.id).toList();
  }

  bool contains(Task task) => state.any((t) => t.id == task.id);

  void clear() {
    state = [];
  }

  bool isEmpty() => state.isEmpty;
}

final selectedTasksProvider =
    NotifierProvider<SelectedTasksNotifier, List<Task>>(
      () => SelectedTasksNotifier(),
    );
