import 'package:blazely/models/group_list.dart';
import 'package:blazely/models/task_list.dart';
import 'package:blazely/models/user.dart';

class Profile {
  final int? id;
  DateTime? birthDate;
  final User? user;
  final String profilePictureUrl;
  List<TaskList>? lists;
  List<GroupList>? groupLists;

  Profile({
    required this.id,
    this.birthDate,
    this.user,
    required this.profilePictureUrl,
    this.lists,
    this.groupLists,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'],
    birthDate:
        json['birth_date'] != null ? DateTime.parse(json['birth_date']) : null,
    user: json['user'] != null ? User.fromJson(json['user']) : null,
    profilePictureUrl: json['profile_picture_url'],
    lists:
        json['lists'] != null
            ? List<TaskList>.from(
              json['lists'].map((x) => TaskList.fromJson(x)),
            )
            : null,
    groupLists:
        json['group_lists'] != null
            ? List<GroupList>.from(
              json['group_lists'].map((x) => GroupList.fromJson(x)),
            )
            : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'birth_date': birthDate?.toIso8601String(),
    'user': user?.toJson(),
    'profile_picture_url': profilePictureUrl,
    'lists': lists?.map((x) => x.toJson()).toList(),
    'group_lists': groupLists?.map((x) => x.toJson()).toList(),
  };
}
