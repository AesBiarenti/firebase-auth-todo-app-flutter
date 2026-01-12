import 'package:firebase_todo_app/data/datasources/firebase_todo_data_source.dart';

import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository_interface.dart';

import '../models/todo_model.dart';

class TodoRepository implements ITodoRepositoryInterface {
  final FirebaseTodoDataSource _dataSource;

  TodoRepository({FirebaseTodoDataSource? dataSource})
      : _dataSource = dataSource ?? FirebaseTodoDataSource();

  @override
  Future<List<Todo>> getTodos(String userId) async {
    try {
      final todos = await _dataSource.getTodos(userId);
      return todos.map((todo) => todo.toEntity()).toList();
    } catch (e) {
      throw Exception('Todolar getirilemedi: $e');
    }
  }

  @override
  Future<Todo?> getTodoById(String id, String userId) async {
    try {
      final todo = await _dataSource.getTodoById(id, userId);
      return todo?.toEntity();
    } catch (e) {
      throw Exception('Todo getirilemedi: $e');
    }
  }

  @override
  Future<Todo> addTodo(Todo todo) async {
    try {
      final todoModel = TodoModel.fromEntity(todo);
      final createdTodo = await _dataSource.addTodo(todoModel);
      return createdTodo.toEntity();
    } catch (e) {
      throw Exception('Todo eklenemedi: $e');
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    try {
      final todoModel = TodoModel.fromEntity(todo);
      await _dataSource.updateTodo(todoModel);
    } catch (e) {
      throw Exception('Todo güncellenemedi: $e');
    }
  }

  @override
  Future<void> deleteTodo(String id, String userId) async {
    try {
      await _dataSource.deleteTodo(id, userId);
    } catch (e) {
      throw Exception('Todo silinemedi: $e');
    }
  }

  @override
  Future<void> updateTodoStatus(
    String id,
    String userId,
    TodoStatus status,
  ) async {
    try {
      await _dataSource.updateTodoStatus(id, userId, status);
    } catch (e) {
      throw Exception('Todo durumu güncellenemedi: $e');
    }
  }

  // Real-time stream için ekstra metod
  Stream<List<Todo>> watchTodos(String userId) {
    return _dataSource.watchTodos(userId).map(
          (todos) => todos.map((todo) => todo.toEntity()).toList(),
        );
  }
}