import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.status,
    required super.createdAt,
    super.updatedAt,
    super.dueDate,
    required super.userId,
  });

  // Entity'den Model'e dönüştürme
  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      status: todo.status,
      createdAt: todo.createdAt,
      updatedAt: todo.updatedAt,
      dueDate: todo.dueDate,
      userId: todo.userId,
    );
  }

  // Firestore'dan Model'e dönüştürme
  factory TodoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TodoModel(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String,
      status: TodoStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => TodoStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      dueDate: data['dueDate'] != null
          ? (data['dueDate'] as Timestamp).toDate()
          : null,
      userId: data['userId'] as String,
    );
  }

  // Model'den Firestore'a dönüştürme
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null
          ? Timestamp.fromDate(updatedAt!)
          : FieldValue.serverTimestamp(),
      'dueDate': dueDate != null
          ? Timestamp.fromDate(dueDate!)
          : null,
      'userId': userId,
    };
  }

  // Entity'ye dönüştürme
  Todo toEntity() {
    return Todo(
      id: id,
      title: title,
      description: description,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      dueDate: dueDate,
      userId: userId,
    );
  }
}