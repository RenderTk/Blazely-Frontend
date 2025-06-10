// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProfileCWProxy {
  Profile id(String id);

  Profile user(User user);

  Profile birthDate(DateTime? birthDate);

  Profile profilePictureUrl(String profilePictureUrl);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Profile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Profile(...).copyWith(id: 12, name: "My name")
  /// ````
  Profile call({
    String id,
    User user,
    DateTime? birthDate,
    String profilePictureUrl,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfProfile.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfProfile.copyWith.fieldName(...)`
class _$ProfileCWProxyImpl implements _$ProfileCWProxy {
  const _$ProfileCWProxyImpl(this._value);

  final Profile _value;

  @override
  Profile id(String id) => this(id: id);

  @override
  Profile user(User user) => this(user: user);

  @override
  Profile birthDate(DateTime? birthDate) => this(birthDate: birthDate);

  @override
  Profile profilePictureUrl(String profilePictureUrl) =>
      this(profilePictureUrl: profilePictureUrl);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Profile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Profile(...).copyWith(id: 12, name: "My name")
  /// ````
  Profile call({
    Object? id = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
    Object? birthDate = const $CopyWithPlaceholder(),
    Object? profilePictureUrl = const $CopyWithPlaceholder(),
  }) {
    return Profile(
      id:
          id == const $CopyWithPlaceholder()
              ? _value.id
              // ignore: cast_nullable_to_non_nullable
              : id as String,
      user:
          user == const $CopyWithPlaceholder()
              ? _value.user
              // ignore: cast_nullable_to_non_nullable
              : user as User,
      birthDate:
          birthDate == const $CopyWithPlaceholder()
              ? _value.birthDate
              // ignore: cast_nullable_to_non_nullable
              : birthDate as DateTime?,
      profilePictureUrl:
          profilePictureUrl == const $CopyWithPlaceholder()
              ? _value.profilePictureUrl
              // ignore: cast_nullable_to_non_nullable
              : profilePictureUrl as String,
    );
  }
}

extension $ProfileCopyWith on Profile {
  /// Returns a callable class that can be used as follows: `instanceOfProfile.copyWith(...)` or like so:`instanceOfProfile.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProfileCWProxy get copyWith => _$ProfileCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
  id: json['id'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  birthDate:
      json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
  profilePictureUrl: json['profile_picture_url'] as String,
);

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
  'id': instance.id,
  'birth_date': instance.birthDate?.toIso8601String(),
  'user': instance.user,
  'profile_picture_url': instance.profilePictureUrl,
};
