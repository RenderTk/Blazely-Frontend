// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LabelCWProxy {
  Label id(int id);

  Label name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Label(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Label(...).copyWith(id: 12, name: "My name")
  /// ````
  Label call({int id, String name});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLabel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLabel.copyWith.fieldName(...)`
class _$LabelCWProxyImpl implements _$LabelCWProxy {
  const _$LabelCWProxyImpl(this._value);

  final Label _value;

  @override
  Label id(int id) => this(id: id);

  @override
  Label name(String name) => this(name: name);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Label(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Label(...).copyWith(id: 12, name: "My name")
  /// ````
  Label call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return Label(
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
    );
  }
}

extension $LabelCopyWith on Label {
  /// Returns a callable class that can be used as follows: `instanceOfLabel.copyWith(...)` or like so:`instanceOfLabel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LabelCWProxy get copyWith => _$LabelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Label _$LabelFromJson(Map<String, dynamic> json) =>
    Label(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$LabelToJson(Label instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};
