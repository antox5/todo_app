
class NoteModel {
  final String id;
  final String title;
  final String description;
  final int? createdAt;

  const NoteModel({
    required this.id,
    required this.title,
    required this.description,
    this.createdAt,
  });

  factory NoteModel.fromJson(Map<dynamic, dynamic> json) {
    return NoteModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt,
    };
  }
}
