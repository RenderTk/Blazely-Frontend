class TaskStep {
  final int? id;
  String text;

  TaskStep({required this.id, required this.text});

  factory TaskStep.fromJson(Map<String, dynamic> json) =>
      TaskStep(id: json['id'], text: json['text']);

  Map<String, dynamic> toJson() => {'id': id, 'text': text};
}
