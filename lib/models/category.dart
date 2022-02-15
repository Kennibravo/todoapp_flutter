import 'package:flutter/material.dart';

List<Map<String, Object?>> categories = [
  {'id': 'biz', 'name': 'Business', 'color': Colors.red[300]},
  {'id': 'prod', 'name': 'Productivity', 'color': Colors.blue[300]},
  {'id': 'oth', 'name': 'Others', 'color': Colors.orange[300]},
  {'id': 'misc', 'name': 'Miscellaneous', 'color': Colors.purple[300]}
];

class Category {
  final String name;
  final String userId;
  final DateTime createdAt;
  final int numberOfTasks;

  Category(this.name, this.userId, this.createdAt, this.numberOfTasks);
}
