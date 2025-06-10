import 'package:blazely/models/task.dart';

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

  factory TaskList.fromJson(Map<String, dynamic> json) => TaskList(
    id: json['id'],
    name: json['name'],
    emoji: json['emoji'],
    group: json['group'],
    tasks:
        json['tasks'] != null
            ? List<Task>.from(json['tasks'].map((x) => Task.fromJson(x)))
            : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'emoji': emoji,
    'group': group,
    'tasks': tasks?.map((x) => x.toJson()).toList(),
  };

  TaskList copyWith({
    int? id,
    String? name,
    String? emoji,
    int? group,
    List<Task>? tasks,
  }) {
    return TaskList(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      group: group ?? this.group,
      tasks: tasks ?? this.tasks,
    );
  }
}
