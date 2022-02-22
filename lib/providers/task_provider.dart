import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/models/category.dart';
import 'package:todoapp/models/task.dart';

class TaskProvider extends ChangeNotifier {
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
}
