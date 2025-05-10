import 'package:blazely/models/task.dart';

class TaskList {
  final int? id;
  String name;
  String emoji;
  List<Task>? tasks;

  TaskList({
    required this.id,
    required this.name,
    required this.emoji,
    this.tasks,
  });

  factory TaskList.fromJson(Map<String, dynamic> json) => TaskList(
    id: json['id'],
    name: json['name'],
    emoji: json['emoji'],
    tasks:
        json['tasks'] != null
            ? List<Task>.from(json['tasks'].map((x) => Task.fromJson(x)))
            : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'emoji': emoji,
    'tasks': tasks?.map((x) => x.toJson()).toList(),
  };
}
