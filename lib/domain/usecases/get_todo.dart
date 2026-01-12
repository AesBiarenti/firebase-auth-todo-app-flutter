import 'package:firebase_todo_app/domain/entities/todo.dart';
import 'package:firebase_todo_app/domain/repositories/todo_repository_interface.dart';

class GetTodo {
  final ITodoRepositoryInterface repository;
  GetTodo(this.repository);
  Future<List<Todo>> call(String userId) {
    return repository.getTodos(userId);
  }
}
