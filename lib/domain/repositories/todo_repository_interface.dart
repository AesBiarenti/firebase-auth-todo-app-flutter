import 'package:firebase_todo_app/domain/entities/todo.dart';

abstract class ITodoRepositoryInterface {
  Future<List<Todo>> getTodos(String userId);
  Future<Todo?> getTodoById(String id, String userId);
  Future<Todo> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id, String userId);
  Future<void> updateTodoStatus(String id, String userId, TodoStatus status);
}
