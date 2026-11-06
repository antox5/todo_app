
class TaskModel {
  final String id;
  final String? title;
  final String? description;
  final int? createdAt;
  final bool isCompleted;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.createdAt,
    this.isCompleted = false,
  });

  factory TaskModel.fromJson(Map<dynamic, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'isCompleted': isCompleted,
    };
  }

  TaskModel copyWith({
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
