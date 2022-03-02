import 'package:flutter/material.dart';
import 'package:todoapp/models/category.dart';
import 'package:todoapp/models/category_task.dart';

class CategoryTaskProvider extends ChangeNotifier {
  List<CategoryTask>? _categoryTasks;

  Future<void> addCategoryToCategoryTask(
      Category category, int numberOfTasks) async {
    _categoryTasks!.add(CategoryTask(category, numberOfTasks));
  }
}
