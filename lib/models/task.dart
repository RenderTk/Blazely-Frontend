import 'package:blazely/models/group_list.dart';
import 'package:blazely/models/label.dart';
import 'package:blazely/models/task_list.dart';
import 'package:blazely/utils/date_time_parsers.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

class TaskOnDynamicListContext {
  final TaskList taskList;
  final GroupList? groupList;

  TaskOnDynamicListContext(this.taskList, this.groupList);
}

@JsonSerializable()
@CopyWith()
class Task {
  final int id;
  String text;
  String? note;

  @JsonKey(name: 'is_completed')
  bool isCompleted;

  @JsonKey(name: 'is_important')
  bool isImportant;

  @JsonKey(name: 'due_date', fromJson: _dateFromJson, toJson: _dateToJson)
  DateTime? dueDate;

  @JsonKey(
    name: 'reminder_date',
    fromJson: _reminderDateFromJson,
    toJson: _reminderDateToJson,
  )
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

  // Custom serialization methods for dates using DateTimeFormats
  static DateTime? _dateFromJson(String? json) {
    return DateTime.tryParse(json ?? '');
  }

  static String? _dateToJson(DateTime? date) {
    return date != null ? DateTimeFormats.formatApiDate(date) : null;
  }

  static DateTime? _reminderDateFromJson(String? json) {
    return DateTime.tryParse(json ?? '');
  }

  static String? _reminderDateToJson(DateTime? date) {
    return date != null ? DateTimeFormats.formatApiDateTime(date) : null;
  }

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

extension TaskDateFormat on Task {
  String? get formattedDueDate => _formatDate(dueDate);
  String? get formattedReminderDate => _formatDateTime(reminderDate);

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return DateTimeFormats.userDate.format(date);
  }

  String? _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return null;
    return DateTimeFormats.userDateTime.format(dateTime);
  }
}
