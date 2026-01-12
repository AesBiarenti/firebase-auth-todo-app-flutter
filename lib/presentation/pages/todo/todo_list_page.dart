import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/todo.dart';
import '../../providers/todo_provider.dart';
import 'add_edit_todo_page.dart';

class TodoListPage extends ConsumerWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todoListStreamProvider);

    return todosAsync.when(
      data: (todos) {
        if (todos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt,
                  size: 80,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'Henüz todo yok',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Yeni bir todo eklemek için + butonuna tıklayın',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Durumlara göre filtreleme
        final pendingTodos = todos.where((t) => t.status == TodoStatus.pending).toList();
        final inProgressTodos = todos.where((t) => t.status == TodoStatus.inProgress).toList();
        final completedTodos = todos.where((t) => t.status == TodoStatus.completed).toList();

        return RefreshIndicator(
          onRefresh: () async {
            // Stream otomatik güncelleniyor
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (pendingTodos.isNotEmpty) ...[
                _buildSectionHeader(context, 'Beklemede', pendingTodos.length),
                const SizedBox(height: 8),
                ...pendingTodos.map((todo) => _buildTodoCard(context, ref, todo)),
                const SizedBox(height: 24),
              ],
              if (inProgressTodos.isNotEmpty) ...[
                _buildSectionHeader(context, 'Devam Ediyor', inProgressTodos.length),
                const SizedBox(height: 8),
                ...inProgressTodos.map((todo) => _buildTodoCard(context, ref, todo)),
                const SizedBox(height: 24),
              ],
              if (completedTodos.isNotEmpty) ...[
                _buildSectionHeader(context, 'Tamamlandı', completedTodos.length),
                const SizedBox(height: 8),
                ...completedTodos.map((todo) => _buildTodoCard(context, ref, todo)),
              ],
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Hata: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(todoListStreamProvider),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(width: 8),
        Chip(
          label: Text('$count'),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }

  Widget _buildTodoCard(BuildContext context, WidgetRef ref, Todo todo) {
    final todoController = ref.read(todoControllerProvider);
    final dateFormat = DateFormat('dd MMM yyyy', 'tr_TR');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditTodoPage(todo: todo),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      todo.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            decoration: todo.status == TodoStatus.completed
                                ? TextDecoration.lineThrough
                                : null,
                            color: todo.status == TodoStatus.completed
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                : null,
                          ),
                    ),
                  ),
                  // Durum badge
                  _buildStatusChip(todo.status),
                ],
              ),
              if (todo.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  todo.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (todo.dueDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dateFormat.format(todo.dueDate!),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Durum değiştir butonları
                  if (todo.status != TodoStatus.completed)
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      tooltip: 'Tamamlandı olarak işaretle',
                      onPressed: () async {
                        try {
                          await todoController.updateTodoStatus(
                            todo.id,
                            TodoStatus.completed,
                          );
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Hata: $e')),
                            );
                          }
                        }
                      },
                    ),
                  if (todo.status == TodoStatus.pending)
                    IconButton(
                      icon: const Icon(Icons.play_circle_outline),
                      tooltip: 'Devam Ediyor olarak işaretle',
                      onPressed: () async {
                        try {
                          await todoController.updateTodoStatus(
                            todo.id,
                            TodoStatus.inProgress,
                          );
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Hata: $e')),
                            );
                          }
                        }
                      },
                    ),
                  // Sil butonu
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Sil',
                    color: Colors.red,
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Todo Sil'),
                          content: const Text('Bu todo\'yu silmek istediğinize emin misiniz?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('İptal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Sil'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        try {
                          await todoController.deleteTodo(todo.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Todo silindi'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Hata: $e')),
                            );
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(TodoStatus status) {
    Color color;
    switch (status) {
      case TodoStatus.pending:
        color = AppColors.todoPending;
        break;
      case TodoStatus.inProgress:
        color = AppColors.todoInProgress;
        break;
      case TodoStatus.completed:
        color = AppColors.todoCompleted;
        break;
    }

    return Chip(
      label: Text(
        status.displayName,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
    );
  }
}

