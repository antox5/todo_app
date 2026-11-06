
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:todo_app/controllers/services.dart';
import 'package:todo_app/views/add_task_screen.dart';
import 'package:todo_app/views/tasks_screen.dart';
import 'add_note_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Service service =  Service();

  Future<void> logout(BuildContext context) async {
    try {
      await service.logout();
      // Auth state listener in main.dart handles navigation.
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = service.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Notes', style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber,
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TasksScreen(),
                ),
              );
            },
            icon: const Icon(Icons.checklist),
            label: const Text('View Tasks'),
          ),

          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
          ),
          
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber,Colors.orange, Colors.deepOrange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Hello ${user?.displayName ?? user?.email?.split('@')[0].toUpperCase() ?? 'User'}!',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
        
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Your Notes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: service.getNotes(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Failed to load notes'),
                    );
                  }
        
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
        
                  final value = snapshot.data?.snapshot.value;
        
                  if (value == null) {
                    return const Center(
                      child: Text('No notes yet. Add your first note!'),
                    );
                  }
        
                  final notes = Map<dynamic, dynamic>.from(
                    value as Map,
                  );
        
                  final entries = notes.entries.toList();
        
                  return ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final noteId = entries[index].key.toString();
        
                      final note = Map<dynamic, dynamic>.from(
                        entries[index].value as Map,
                      );
        
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        child: ListTile(
                          title: Text(note['title'] ?? ''),
                          subtitle: Text(note['description'] ?? ''),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              try {
                                await service.deleteNote(noteId);
                              } catch (e) {
                                if (!context.mounted) return;
        
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Delete failed: $e'),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'add_note',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddNoteScreen(),
                ),
              );
            },
            icon: const Icon(Icons.note_add),
            label: const Text('Add Note'),
          ),

          const SizedBox(height: 12),

          FloatingActionButton.extended(
            heroTag: 'add_task',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddTaskScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add_task),
            label: const Text('Add Task'),
          ),
        ],
      ),
    );
  }
}
