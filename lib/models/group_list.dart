import 'package:blazely/models/task_list.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group_list.g.dart';

@JsonSerializable()
@CopyWith()
class GroupList {
  final int id;
  String name;
  List<TaskList>? lists;

  GroupList({required this.id, required this.name, this.lists});

  factory GroupList.fromJson(Map<String, dynamic> json) =>
      _$GroupListFromJson(json);

  Map<String, dynamic> toJson() => _$GroupListToJson(this);
}
