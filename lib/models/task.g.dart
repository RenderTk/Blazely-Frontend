// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TaskCWProxy {
  Task id(int id);

  Task text(String text);

  Task note(String? note);

  Task isCompleted(bool isCompleted);

  Task isImportant(bool isImportant);

  Task dueDate(DateTime? dueDate);

  Task reminderDate(DateTime? reminderDate);

  Task priority(String priority);

  Task label(Label? label);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Task(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Task(...).copyWith(id: 12, name: "My name")
  /// ````
  Task call({
    int id,
    String text,
    String? note,
    bool isCompleted,
    bool isImportant,
    DateTime? dueDate,
    DateTime? reminderDate,
    String priority,
    Label? label,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTask.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTask.copyWith.fieldName(...)`
class _$TaskCWProxyImpl implements _$TaskCWProxy {
  const _$TaskCWProxyImpl(this._value);

  final Task _value;

  @override
  Task id(int id) => this(id: id);

  @override
  Task text(String text) => this(text: text);

  @override
  Task note(String? note) => this(note: note);

  @override
  Task isCompleted(bool isCompleted) => this(isCompleted: isCompleted);

  @override
  Task isImportant(bool isImportant) => this(isImportant: isImportant);

  @override
  Task dueDate(DateTime? dueDate) => this(dueDate: dueDate);

  @override
  Task reminderDate(DateTime? reminderDate) => this(reminderDate: reminderDate);

  @override
  Task priority(String priority) => this(priority: priority);

  @override
  Task label(Label? label) => this(label: label);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Task(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Task(...).copyWith(id: 12, name: "My name")
  /// ````
  Task call({
    Object? id = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? isCompleted = const $CopyWithPlaceholder(),
    Object? isImportant = const $CopyWithPlaceholder(),
    Object? dueDate = const $CopyWithPlaceholder(),
    Object? reminderDate = const $CopyWithPlaceholder(),
    Object? priority = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
  }) {
    return Task(
      id:
          id == const $CopyWithPlaceholder()
              ? _value.id
              // ignore: cast_nullable_to_non_nullable
              : id as int,
      text:
          text == const $CopyWithPlaceholder()
              ? _value.text
              // ignore: cast_nullable_to_non_nullable
              : text as String,
      note:
          note == const $CopyWithPlaceholder()
              ? _value.note
              // ignore: cast_nullable_to_non_nullable
              : note as String?,
      isCompleted:
          isCompleted == const $CopyWithPlaceholder()
              ? _value.isCompleted
              // ignore: cast_nullable_to_non_nullable
              : isCompleted as bool,
      isImportant:
          isImportant == const $CopyWithPlaceholder()
              ? _value.isImportant
              // ignore: cast_nullable_to_non_nullable
              : isImportant as bool,
      dueDate:
          dueDate == const $CopyWithPlaceholder()
              ? _value.dueDate
              // ignore: cast_nullable_to_non_nullable
              : dueDate as DateTime?,
      reminderDate:
          reminderDate == const $CopyWithPlaceholder()
              ? _value.reminderDate
              // ignore: cast_nullable_to_non_nullable
              : reminderDate as DateTime?,
      priority:
          priority == const $CopyWithPlaceholder()
              ? _value.priority
              // ignore: cast_nullable_to_non_nullable
              : priority as String,
      label:
          label == const $CopyWithPlaceholder()
              ? _value.label
              // ignore: cast_nullable_to_non_nullable
              : label as Label?,
    );
  }
}

extension $TaskCopyWith on Task {
  /// Returns a callable class that can be used as follows: `instanceOfTask.copyWith(...)` or like so:`instanceOfTask.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TaskCWProxy get copyWith => _$TaskCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
  id: (json['id'] as num).toInt(),
  text: json['text'] as String,
  note: json['note'] as String?,
  isCompleted: json['is_completed'] as bool,
  isImportant: json['is_important'] as bool,
  dueDate: Task._dateFromJson(json['due_date'] as String?),
  reminderDate: Task._reminderDateFromJson(json['reminder_date'] as String?),
  priority: json['priority'] as String,
  label:
      json['label'] == null
          ? null
          : Label.fromJson(json['label'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'note': instance.note,
  'is_completed': instance.isCompleted,
  'is_important': instance.isImportant,
  'due_date': Task._dateToJson(instance.dueDate),
  'reminder_date': Task._reminderDateToJson(instance.reminderDate),
  'priority': instance.priority,
  'label': instance.label,
};
