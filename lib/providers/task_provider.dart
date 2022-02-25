import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/category.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/providers/category_provider.dart';

class TaskProvider extends ChangeNotifier {
  List<Category> categories;

  TaskProvider(this.categories);

  List<Task>? _tasks = [];

  final baseCollection = 'users_new';
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Task> get tasks {
    return [..._tasks!];
  }

  Future<void> addTask({
    required String title,
    required String content,
    required Category category,
    required DateTime date,
  }) async {
    final collection = firestore
        .collection('tasks')
        .doc(auth.currentUser!.uid)
        .collection('task');

    try {
      final task = await collection.add({
        'title': title,
        'content': content,
        'date': date,
        'status': 'pending',
        'categories': {category.name: true},
      });

      final newTask = Task(
        id: task.id,
        title: title,
        content: content,
        category: category,
        status: 'pending',
        date: date,
      );

      _tasks!.add(newTask);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> changeTaskStatus(
      String id, String status, BuildContext context) async {
    await firestore
        .collection('tasks')
        .doc(auth.currentUser!.uid)
        .collection('task')
        .doc(id)
        .update({'status': status});

    final task = _tasks!.firstWhere((task) => task.id == id);
    task.status = status;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text('Task set to $status!'),
      ),
    );

    notifyListeners();
    print('everything works');
  }

  Future<void> getAllTasks() async {
    print(categories);

    print('In provider');

    final allTasks = await firestore
        .collection('tasks')
        .doc(auth.currentUser!.uid)
        .collection('task')
        .get();

    allTasks.docs.map((doc) {
      final singleTask = doc.data();
      final categoryForTask =
          (doc.data()['categories'] as Map<String, dynamic>).keys.elementAt(0);

      _tasks!.add(
        Task(
            id: doc.id,
            title: singleTask['title'],
            content: singleTask['content'],
            category: Category(
                categoryForTask, auth.currentUser!.uid, DateTime.now(), 0),
            status: singleTask['status'],
            date: DateTime.parse(singleTask['date'].toString())),
      );
    }).toList();

    notifyListeners();
  }

  Task getSingleTask(String id) {
    Task singleTask = _tasks!.firstWhere((task) => task.id == id);

    return singleTask;
  }
}
