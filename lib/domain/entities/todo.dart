enum TodoStatus {
  pending,
  inProgress,
  completed;

  String get displayName {
    switch (this) {
      case TodoStatus.pending:
        return 'Beklemede';
      case TodoStatus.inProgress:
        return 'Devam Ediyor';
      case TodoStatus.completed:
        return 'Tamamlandı';
    }
  }
}

class Todo {
  final String id;
  final String title;
  final String description;
  final TodoStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? dueDate;
  final String userId; // Hangi kullanıcıya ait olduğu

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.dueDate,
    required this.userId,
  });

  // CopyWith metodu - güncellemeler için
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    TodoStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    String? userId,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueDate: dueDate ?? this.dueDate,
      userId: userId ?? this.userId,
    );
  }

  // Equality override
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Todo && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
