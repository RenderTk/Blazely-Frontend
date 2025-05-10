import 'package:blazely/models/user.dart';

class Profile {
  final String? id;
  DateTime? birthDate;
  final User? user;
  final String profilePictureUrl;

  Profile({
    required this.id,
    this.birthDate,
    this.user,
    required this.profilePictureUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'],
    birthDate:
        json['birth_date'] != null ? DateTime.parse(json['birth_date']) : null,
    user: json['user'] != null ? User.fromJson(json['user']) : null,
    profilePictureUrl: json['profile_picture_url'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'birth_date': birthDate?.toIso8601String(),
    'user': user?.toJson(),
    'profile_picture_url': profilePictureUrl,
  };
}
