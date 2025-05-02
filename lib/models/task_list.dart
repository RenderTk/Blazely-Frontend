import 'package:blazely/models/task.dart';

class TaskList {
  final int? id;
  String name;
  List<Task>? tasks;

  TaskList({required this.id, required this.name, this.tasks});

  factory TaskList.fromJson(Map<String, dynamic> json) => TaskList(
    id: json['id'],
    name: json['name'],
    tasks:
        json['tasks'] != null
            ? List<Task>.from(json['tasks'].map((x) => Task.fromJson(x)))
            : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tasks': tasks?.map((x) => x.toJson()).toList(),
  };
}
