// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_step.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TaskStepCWProxy {
  TaskStep id(int id);

  TaskStep text(String text);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TaskStep(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TaskStep(...).copyWith(id: 12, name: "My name")
  /// ````
  TaskStep call({int id, String text});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTaskStep.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTaskStep.copyWith.fieldName(...)`
class _$TaskStepCWProxyImpl implements _$TaskStepCWProxy {
  const _$TaskStepCWProxyImpl(this._value);

  final TaskStep _value;

  @override
  TaskStep id(int id) => this(id: id);

  @override
  TaskStep text(String text) => this(text: text);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TaskStep(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TaskStep(...).copyWith(id: 12, name: "My name")
  /// ````
  TaskStep call({
    Object? id = const $CopyWithPlaceholder(),
    Object? text = const $CopyWithPlaceholder(),
  }) {
    return TaskStep(
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
    );
  }
}

extension $TaskStepCopyWith on TaskStep {
  /// Returns a callable class that can be used as follows: `instanceOfTaskStep.copyWith(...)` or like so:`instanceOfTaskStep.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TaskStepCWProxy get copyWith => _$TaskStepCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskStep _$TaskStepFromJson(Map<String, dynamic> json) =>
    TaskStep(id: (json['id'] as num).toInt(), text: json['text'] as String);

Map<String, dynamic> _$TaskStepToJson(TaskStep instance) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
};
