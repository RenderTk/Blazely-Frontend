import 'package:blazely/models/label.dart';

class Task {
  final int? id;
  String? title;
  String? note;
  bool? isCompleted;
  bool? isImportant;
  DateTime? dueDate;
  DateTime? reminderDate;
  String priority;
  final Label label;

  Task({
    required this.id,
    required this.title,
    required this.note,
    required this.isCompleted,
    required this.isImportant,
    this.dueDate,
    this.reminderDate,
    required this.priority,
    required this.label,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    note: json['note'],
    isCompleted: json['is_completed'],
    isImportant: json['is_important'],
    dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
    reminderDate:
        json['reminder_date'] != null
            ? DateTime.parse(json['reminder_date'])
            : null,
    priority: json['priority'],
    label: Label.fromJson(json['label']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'note': note,
    'is_completed': isCompleted,
    'is_important': isImportant,
    'due_date': dueDate?.toIso8601String(),
    'reminder_date': reminderDate?.toIso8601String(),
    'priority': priority,
    'label': label.toJson(),
  };
}
