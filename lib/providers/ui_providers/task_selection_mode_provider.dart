import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskSelectionModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void enable() => state = true;

  void disable() => state = false;

  void toggle() => state = !state;
}

final taskSelectionModeProvider =
    NotifierProvider<TaskSelectionModeNotifier, bool>(
      TaskSelectionModeNotifier.new,
    );
