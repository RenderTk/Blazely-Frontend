class Label {
  final int id;
  String name;

  Label({required this.id, required this.name});

  factory Label.fromJson(Map<String, dynamic> json) =>
      Label(id: json['id'], name: json['name']);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
