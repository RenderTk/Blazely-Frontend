// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

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
