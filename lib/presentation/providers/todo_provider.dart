import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/todo_repository.dart';
import '../../domain/entities/todo.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_todo.dart';
import '../../domain/usecases/update_todo.dart';
import 'auth_providers.dart';

// Repository provider
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepository();
});

// Use cases providers
final addTodoUseCaseProvider = Provider<AddTodo>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return AddTodo(repository);
});

final getTodosUseCaseProvider = Provider<GetTodo>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return GetTodo(repository);
});

final updateTodoUseCaseProvider = Provider<UpdateTodo>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return UpdateTodo(repository);
});

final deleteTodoUseCaseProvider = Provider<DeleteTodo>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return DeleteTodo(repository);
});

// Todo list stream provider - real-time güncellemeler için
final todoListStreamProvider = StreamProvider<List<Todo>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    return Stream.value([]);
  }

  final repository = ref.watch(todoRepositoryProvider);
  return repository.watchTodos(user.uid);
});

// Todo controller provider
final todoControllerProvider = Provider<TodoController>((ref) {
  return TodoController(ref);
});

class TodoController {
  final Ref _ref;

  TodoController(this._ref);

  // Yeni todo ekle
  Future<void> addTodo({
    required String title,
    required String description,
    DateTime? dueDate,
  }) async {
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) {
        throw Exception('Kullanıcı giriş yapmamış');
      }

      final addTodoUseCase = _ref.read(addTodoUseCaseProvider);
      final todo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        status: TodoStatus.pending,
        createdAt: DateTime.now(),
        dueDate: dueDate,
        userId: user.uid,
      );

      await addTodoUseCase(todo);
    } catch (e) {
      throw Exception('Todo eklenirken hata oluştu: $e');
    }
  }

  // Todo güncelle
  Future<void> updateTodo(Todo todo) async {
    try {
      final updateTodoUseCase = _ref.read(updateTodoUseCaseProvider);
      final updatedTodo = todo.copyWith(updatedAt: DateTime.now());
      await updateTodoUseCase(updatedTodo);
    } catch (e) {
      throw Exception('Todo güncellenirken hata oluştu: $e');
    }
  }

  // Todo sil
  Future<void> deleteTodo(String id) async {
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) {
        throw Exception('Kullanıcı giriş yapmamış');
      }

      final deleteTodoUseCase = _ref.read(deleteTodoUseCaseProvider);
      await deleteTodoUseCase(id, user.uid);
    } catch (e) {
      throw Exception('Todo silinirken hata oluştu: $e');
    }
  }

  // Todo durumunu güncelle
  Future<void> updateTodoStatus(String id, TodoStatus status) async {
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) {
        throw Exception('Kullanıcı giriş yapmamış');
      }

      final repository = _ref.read(todoRepositoryProvider);
      await repository.updateTodoStatus(id, user.uid, status);
    } catch (e) {
      throw Exception('Todo durumu güncellenirken hata oluştu: $e');
    }
  }
}
