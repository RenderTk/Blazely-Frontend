// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_list.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$GroupListCWProxy {
  GroupList id(int id);

  GroupList name(String name);

  GroupList lists(List<TaskList>? lists);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GroupList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GroupList(...).copyWith(id: 12, name: "My name")
  /// ````
  GroupList call({int id, String name, List<TaskList>? lists});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfGroupList.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfGroupList.copyWith.fieldName(...)`
class _$GroupListCWProxyImpl implements _$GroupListCWProxy {
  const _$GroupListCWProxyImpl(this._value);

  final GroupList _value;

  @override
  GroupList id(int id) => this(id: id);

  @override
  GroupList name(String name) => this(name: name);

  @override
  GroupList lists(List<TaskList>? lists) => this(lists: lists);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `GroupList(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// GroupList(...).copyWith(id: 12, name: "My name")
  /// ````
  GroupList call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? lists = const $CopyWithPlaceholder(),
  }) {
    return GroupList(
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
      lists:
          lists == const $CopyWithPlaceholder()
              ? _value.lists
              // ignore: cast_nullable_to_non_nullable
              : lists as List<TaskList>?,
    );
  }
}

extension $GroupListCopyWith on GroupList {
  /// Returns a callable class that can be used as follows: `instanceOfGroupList.copyWith(...)` or like so:`instanceOfGroupList.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$GroupListCWProxy get copyWith => _$GroupListCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupList _$GroupListFromJson(Map<String, dynamic> json) => GroupList(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  lists:
      (json['lists'] as List<dynamic>?)
          ?.map((e) => TaskList.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$GroupListToJson(GroupList instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'lists': instance.lists,
};
