// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TaskListCWProxy {
  TaskList id(int id);

  TaskList name(String name);

  TaskList emoji(String emoji);

  TaskList group(int? group);

  TaskList tasks(List<Task>? tasks);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TaskList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TaskList(...).copyWith(id: 12, name: "My name")
  /// ````
  TaskList call({
    int id,
    String name,
    String emoji,
    int? group,
    List<Task>? tasks,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTaskList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTaskList.copyWith.fieldName(...)`
class _$TaskListCWProxyImpl implements _$TaskListCWProxy {
  const _$TaskListCWProxyImpl(this._value);

  final TaskList _value;

  @override
  TaskList id(int id) => this(id: id);

  @override
  TaskList name(String name) => this(name: name);

  @override
  TaskList emoji(String emoji) => this(emoji: emoji);

  @override
  TaskList group(int? group) => this(group: group);

  @override
  TaskList tasks(List<Task>? tasks) => this(tasks: tasks);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TaskList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TaskList(...).copyWith(id: 12, name: "My name")
  /// ````
  TaskList call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? emoji = const $CopyWithPlaceholder(),
    Object? group = const $CopyWithPlaceholder(),
    Object? tasks = const $CopyWithPlaceholder(),
  }) {
    return TaskList(
      id:
          id == const $CopyWithPlaceholder()
              ? _value.id
              // ignore: cast_nullable_to_non_nullable
              : id as int,
      name:
          name == const $CopyWithPlaceholder()
              ? _value.name
              // ignore: cast_nullable_to_non_nullable
              : name as String,
      emoji:
          emoji == const $CopyWithPlaceholder()
              ? _value.emoji
              // ignore: cast_nullable_to_non_nullable
              : emoji as String,
      group:
          group == const $CopyWithPlaceholder()
              ? _value.group
              // ignore: cast_nullable_to_non_nullable
              : group as int?,
      tasks:
          tasks == const $CopyWithPlaceholder()
              ? _value.tasks
              // ignore: cast_nullable_to_non_nullable
              : tasks as List<Task>?,
    );
  }
}

extension $TaskListCopyWith on TaskList {
  /// Returns a callable class that can be used as follows: `instanceOfTaskList.copyWith(...)` or like so:`instanceOfTaskList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TaskListCWProxy get copyWith => _$TaskListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskList _$TaskListFromJson(Map<String, dynamic> json) => TaskList(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  emoji: json['emoji'] as String,
  group: (json['group'] as num?)?.toInt(),
  tasks:
      (json['tasks'] as List<dynamic>?)
          ?.map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$TaskListToJson(TaskList instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'emoji': instance.emoji,
  'group': instance.group,
  'tasks': instance.tasks,
};
