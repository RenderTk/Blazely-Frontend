import 'package:blazely/models/task_list.dart';

class GroupList {
  final int id;
  String name;
  List<TaskList>? lists;

  GroupList({required this.id, required this.name, this.lists});

  factory GroupList.fromJson(Map<String, dynamic> json) => GroupList(
    id: json['id'],
    name: json['name'],
    lists:
        json['lists'] != null
            ? List<TaskList>.from(
              json['lists'].map((x) => TaskList.fromJson(x)),
            )
            : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'lists': lists?.map((x) => x.toJson()).toList(),
  };

  // GroupList copyWith({int? id, String? name, List<TaskList>? lists}) {
  //   return GroupList(
  //     id: id ?? this.id,
  //     name: name ?? this.name,
  //     lists: lists ?? this.lists,
  //   );
  // }
  GroupList copyWith({int? id, String? name, List<TaskList>? lists}) {
    return GroupList(
      id: id ?? this.id,
      name: name ?? this.name,
      lists:
          lists != null
              ? lists.map((l) => l.copyWith()).toList()
              : this.lists?.map((l) => l.copyWith()).toList(),
    );
  }
}
