import 'package:blazely/models/task.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_list.g.dart';

@JsonSerializable()
@CopyWith()
class TaskList {
  final int id;
  String name;
  String emoji;
  int? group;
  List<Task>? tasks;

  TaskList({
    required this.id,
    required this.name,
    required this.emoji,
    required this.group,
    this.tasks,
  });

  factory TaskList.fromJson(Map<String, dynamic> json) =>
      _$TaskListFromJson(json);

  Map<String, dynamic> toJson() => _$TaskListToJson(this);
}
