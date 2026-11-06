
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todo_app/controllers/services.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final Service service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks', style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber, Colors.orange, Colors.deepOrange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<DatabaseEvent>(
          stream: service.getTasks(),
          builder: (context, snapshot) {
        
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }
        
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        
            final tasks = snapshot.data?.snapshot.children ?? [];
        
            if (tasks.isEmpty) {
              return const Center(
                child: Text(
                  'No tasks yet!',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
        
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
        
              itemBuilder: (context, index) {
                final taskSnapshot = tasks.elementAt(index);
        
                final task = Map<String, dynamic>.from(
                  taskSnapshot.value as Map,
                );
        
                final taskId = taskSnapshot.key!;
                final title = task['title'] ?? '';
                final description = task['description'] ?? '';
                final isCompleted = task['isCompleted'] ?? false;
        
                return Dismissible(
                  key: Key(taskId),
                  direction: DismissDirection.endToStart,
                  background: Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    color: Colors.red,
    child: const Icon(
      Icons.delete,
      color: Colors.white,
    ),
  ),
                  onDismissed: (direction) async {
                    await service.deleteTask(taskId);
        
                    if (!mounted) return;
        
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Task deleted successfully'),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                          
                      subtitle: description.toString().isEmpty
                          ? null
                          : Text(description),
                          
                      trailing: Checkbox(
                        value: isCompleted,
                        onChanged: (value) async {
                          await service.toggleTask(
                            taskId,
                            value ?? false,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
