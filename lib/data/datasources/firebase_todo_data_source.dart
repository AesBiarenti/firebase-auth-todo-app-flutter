import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_app/core/constants/app_constants.dart';
import 'package:firebase_todo_app/data/models/todo_model.dart';
import 'package:firebase_todo_app/domain/entities/todo.dart';

class FirebaseTodoDataSource {
  final FirebaseFirestore _firestore;
  FirebaseTodoDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  //* Tüm Todoları getir kullanıcıya göre filtrelenmiş
  Future<List<TodoModel>> getTodos(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.todosCollection)
          .where('userId', isEqualTo: userId)
          .get();

      final todos = querySnapshot.docs
          .map((doc) => TodoModel.fromFirestore(doc))
          .toList();
      
      // Client tarafında sıralama (index gerektirmez)
      todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      return todos;
    } catch (e) {
      throw Exception('Todolar getirilirken hata oluştu: $e');
    }
  }

  //* Real-time stream - todoları dinle
  Stream<List<TodoModel>> watchTodos(String userId) {
    return _firestore
        .collection(AppConstants.todosCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapShot) {
            final todos = snapShot.docs
                .map((doc) => TodoModel.fromFirestore(doc))
                .toList();
            // Client tarafında sıralama (index gerektirmez)
            todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            return todos;
          },
        );
  }

  // Tek bir todo getir
  Future<TodoModel?> getTodoById(String id, String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.todosCollection)
          .doc(id)
          .get();

      if (!doc.exists) {
        return null;
      }

      final todo = TodoModel.fromFirestore(doc);

      // Kullanıcı kontrolü
      if (todo.userId != userId) {
        throw Exception('Bu todo size ait değil');
      }

      return todo;
    } catch (e) {
      throw Exception('Todo getirilirken hata oluştu: $e');
    }
  }

  // Yeni todo ekle
  Future<TodoModel> addTodo(TodoModel todo) async {
    try {
      final docRef = _firestore
          .collection(AppConstants.todosCollection)
          .doc(todo.id);

      await docRef.set(todo.toFirestore());

      final createdDoc = await docRef.get();
      return TodoModel.fromFirestore(createdDoc);
    } catch (e) {
      throw Exception('Todo eklenirken hata oluştu: $e');
    }
  }

  // Todo güncelle
  Future<void> updateTodo(TodoModel todo) async {
    try {
      final docRef = _firestore
          .collection(AppConstants.todosCollection)
          .doc(todo.id);

      // Kullanıcı kontrolü
      final existingDoc = await docRef.get();
      if (!existingDoc.exists) {
        throw Exception('Todo bulunamadı');
      }

      final existingTodo = TodoModel.fromFirestore(existingDoc);
      if (existingTodo.userId != todo.userId) {
        throw Exception('Bu todo size ait değil');
      }

      // updatedAt'i güncelle
      final updatedTodo = todo.copyWith(updatedAt: DateTime.now());

      await docRef.update(updatedTodo.toFirestore());
    } catch (e) {
      throw Exception('Todo güncellenirken hata oluştu: $e');
    }
  }

  // Todo sil
  Future<void> deleteTodo(String id, String userId) async {
    try {
      final docRef = _firestore
          .collection(AppConstants.todosCollection)
          .doc(id);

      // Kullanıcı kontrolü
      final doc = await docRef.get();
      if (!doc.exists) {
        throw Exception('Todo bulunamadı');
      }

      final todo = TodoModel.fromFirestore(doc);
      if (todo.userId != userId) {
        throw Exception('Bu todo size ait değil');
      }

      await docRef.delete();
    } catch (e) {
      throw Exception('Todo silinirken hata oluştu: $e');
    }
  }

  // Todo durumunu güncelle
  Future<void> updateTodoStatus(
    String id,
    String userId,
    TodoStatus status,
  ) async {
    try {
      final todo = await getTodoById(id, userId);
      if (todo == null) {
        throw Exception('Todo bulunamadı');
      }

      final updatedTodo = todo.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );

      await updateTodo(updatedTodo);
    } catch (e) {
      throw Exception('Todo durumu güncellenirken hata oluştu: $e');
    }
  }
}
