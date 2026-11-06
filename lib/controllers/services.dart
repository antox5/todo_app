
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Service {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  

  User? get currentUser => _auth.currentUser;

  // Sign Up
  Future<UserCredential> signUp(
    String email,
    String password,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Login
  Future<UserCredential> login(
    String email,
    String password,
  ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Authentication State
 Stream<User?> get authStateChanges {
  return _auth.authStateChanges();
}



  DatabaseReference get _userRef {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    return _database.ref('users/${user.uid}');
  }

 

  // Add Note
  Future<void> addNote({
    required String title,
    required String description,
  }) async {
    final noteRef = _userRef.child('notes').push();

    await noteRef.set({
      'id': noteRef.key,
      'title': title,
      'description': description,
      'createdAt': ServerValue.timestamp,
    });
  }

  // Get Notes
  Stream<DatabaseEvent> getNotes() {
    return _userRef.child('notes').onValue;
  }

  // Update Note
  Future<void> updateNote({
    required String noteId,
    required String title,
    required String description,
  }) async {
    await _userRef.child('notes/$noteId').update({
      'title': title,
      'description': description,
    });
  }

  // Delete Note
  Future<void> deleteNote(String noteId) async {
    await _userRef.child('notes/$noteId').remove();
  }

 

  // Add Task
  Future<void> addTask({
    required String title,
    required String description,
  }) async {
    final taskRef = _userRef.child('tasks').push();

    await taskRef.set({
      'id': taskRef.key,
      'title': title,
      'description': description,
      'createdAt': ServerValue.timestamp,
      'isCompleted': false,
    });
  }

  // Get Tasks
  Stream<DatabaseEvent> getTasks() {
    return _userRef.child('tasks').onValue;
  }

  // Update Task
  Future<void> updateTask({
    required String taskId,
    required String title,
    required String description,
  }) async {
    await _userRef.child('tasks/$taskId').update({
      'title': title,
      'description': description,
    });
  }

  // Toggle Task Completion
  Future<void> toggleTask(String taskId, bool isCompleted) async {
    await _userRef.child('tasks/$taskId').update({
      'isCompleted': isCompleted,
    });
  }

  // Delete Task
  Future<void> deleteTask(String taskId) async {
    await _userRef.child('tasks/$taskId').remove();
  }

 
}
