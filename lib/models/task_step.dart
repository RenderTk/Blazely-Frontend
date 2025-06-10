import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_step.g.dart';

@JsonSerializable()
@CopyWith()
class TaskStep {
  final int id;
  final String text;

  TaskStep({required this.id, required this.text});

  factory TaskStep.fromJson(Map<String, dynamic> json) =>
      _$TaskStepFromJson(json);

  Map<String, dynamic> toJson() => _$TaskStepToJson(this);
}
