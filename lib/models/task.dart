import 'package:todoapp/models/category.dart';

class Task {
  final String id;
  final String title;
  final String content;
  final Category category;
  final String status;
  final DateTime date;

  Task({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.status,
    required this.date,
  });
}
