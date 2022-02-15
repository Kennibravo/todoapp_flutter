import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/models/category.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category>? _categories = [];
  final baseCollection = 'users_new';

  List<Category> get categories {
    return [..._categories!];
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createCategory(String name) async {
    final userDetails =
        await firestore.collection('users').doc(auth.currentUser!.uid).get();

    try {
      final category = await firestore.collection('categories').doc(name).set({
        'name': name,
        'created_at': DateTime.now(),
        'users': {userDetails['username']: true}
      });

      final newCategory = Category(name, auth.currentUser!.uid, DateTime.now(), 0);
      _categories!.add(newCategory);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllCategories() async {
    try {
      var uid = auth.currentUser!.uid;

      final userDetails = await firestore.collection('users').doc(uid).get();

      final String username = ('users.${userDetails['username']}');

      final category = await firestore
          .collection('categories')
          .where(username, isEqualTo: true)
          .get();

      category.docs.map((doc) async {
        final data = doc.data();
        final String categoryMap = ('categories.${data['name']}');

        final totalTaskInCategory = await firestore
            .collection('tasks')
            .doc(uid)
            .collection('task')
            .where(categoryMap, isEqualTo: true)
            .get();

        print(data);
        print(totalTaskInCategory.docs.length);

        _categories!.add(
          Category(
            data['name'],
            uid,
            DateTime.now(),
            totalTaskInCategory.docs.length,
          ),
        );

        notifyListeners();
      }).toList();
    } catch (e) {
      print(e);
    }
  }
}
