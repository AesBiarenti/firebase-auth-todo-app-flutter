import 'package:firebase_todo_app/domain/entities/todo.dart';
import 'package:firebase_todo_app/domain/repositories/todo_repository_interface.dart';

class UpdateTodo {
  final ITodoRepositoryInterface repository;
  UpdateTodo(this.repository);
  Future<void> call(Todo todo) {
    return repository.updateTodo(todo);
  }
}
