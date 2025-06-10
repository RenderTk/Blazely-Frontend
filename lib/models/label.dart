import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'label.g.dart';

@JsonSerializable()
@CopyWith()
class Label {
  final int id;
  final String name;

  Label({required this.id, required this.name});

  factory Label.fromJson(Map<String, dynamic> json) => _$LabelFromJson(json);

  Map<String, dynamic> toJson() => _$LabelToJson(this);
}
