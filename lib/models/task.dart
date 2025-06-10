import 'package:blazely/models/group_list.dart';
import 'package:blazely/models/label.dart';
import 'package:blazely/models/task_list.dart';
import 'package:intl/intl.dart';

enum TaskBoleanProperty { isCompleted, isImportant }

class TaskOnDynamicListContext {
  final TaskList taskList;
  final GroupList? groupList;

  TaskOnDynamicListContext(this.taskList, this.groupList);
}

class Task {
  final int id;
  String text;
  String? note;
  bool isCompleted;
  bool isImportant;
  DateTime? dueDate;
  DateTime? reminderDate;
  String priority;
  Label? label;

  Task({
    required this.id,
    required this.text,
    required this.note,
    required this.isCompleted,
    required this.isImportant,
    this.dueDate,
    this.reminderDate,
    required this.priority,
    required this.label,
  });

  Task.empty({
    this.id = -1,
    this.priority = '',
    this.text = '',
    this.isCompleted = false,
    this.isImportant = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    text: json['text'],
    note: json['note'],
    isCompleted: json['is_completed'],
    isImportant: json['is_important'],
    dueDate:
        json['due_date'] != null ? DateTime.tryParse(json['due_date']) : null,
    reminderDate:
        json['reminder_date'] != null
            ? DateTime.tryParse(json['reminder_date'])
            : null,
    priority: json['priority'],
    label: json['label'] != null ? Label.fromJson(json['label']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'note': note,
    'is_completed': isCompleted,
    'is_important': isImportant,
    'due_date':
        dueDate != null ? DateFormat('yyyy-MM-dd').format(dueDate!) : null,
    'reminder_date': reminderDate?.toUtc().toIso8601String(),
    'priority': priority,
    'label': label?.toJson(),
  };

  Task copyWith({
    int? id,
    String? text,
    String? note,
    bool? isCompleted,
    bool? isImportant,
    DateTime? dueDate,
    DateTime? reminderDate,
    String? priority,
    Label? label,
  }) {
    return Task(
      id: id ?? this.id,
      text: text ?? this.text,
      note: note ?? this.note,
      isCompleted: isCompleted ?? this.isCompleted,
      isImportant: isImportant ?? this.isImportant,
      dueDate: dueDate ?? this.dueDate,
      reminderDate: reminderDate ?? this.reminderDate,
      priority: priority ?? this.priority,
      label: label ?? this.label,
    );
  }
}

extension TaskDateFormat on Task {
  String? get formattedDueDate => _formatDate(dueDate);
  String? get formattedReminderDate => _formatDate(reminderDate);

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    final formatter = DateFormat(
      'EEE, d \'de\' MMM, y',
      Intl.getCurrentLocale(),
    );
    return formatter.format(date);
  }
}
