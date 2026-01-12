import 'package:firebase_todo_app/domain/repositories/todo_repository_interface.dart';

class DeleteTodo {
  final ITodoRepositoryInterface repository;
  DeleteTodo(this.repository);
  Future<void> call(String id, String userId) {
    return repository.deleteTodo(id, userId);
  }
}
