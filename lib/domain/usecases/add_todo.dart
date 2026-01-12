import 'package:firebase_todo_app/domain/entities/todo.dart';
import 'package:firebase_todo_app/domain/repositories/todo_repository_interface.dart';

class AddTodo {
  final ITodoRepositoryInterface repository;
  AddTodo(this.repository);
  Future<Todo> call(Todo todo) {
    return repository.addTodo(todo);
  }
}
