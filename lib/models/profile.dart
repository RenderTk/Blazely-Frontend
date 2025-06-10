import 'package:json_annotation/json_annotation.dart';
import 'package:blazely/models/user.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  final String id;

  @JsonKey(name: 'birth_date')
  DateTime? birthDate;

  final User user;

  @JsonKey(name: 'profile_picture_url')
  final String profilePictureUrl;

  Profile({
    required this.id,
    required this.user,
    this.birthDate,
    required this.profilePictureUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
