import 'dart:math';
import 'package:flutter/material.dart';
import 'package:todoapp/models/tasks.dart';

class TaskItem extends StatelessWidget {
  TaskItem({Key? key}) : super(key: key);
  final List<Color?> colors = [Colors.red[500], Colors.blue[500]];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        // shrinkWrap: true,
        itemCount: tasks.length,
        itemBuilder: (ctx, index) {
          var random = Random().nextInt(colors.length);
          var randomColor = colors[random];

          return Container(
            child: Card(
              elevation: 0.8,
              shadowColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading:
                    Icon(Icons.circle_outlined, size: 35, color: randomColor),
                title: Text(tasks[index]['title']!),
                trailing: Container(
                  height: 20,
                  child: ElevatedButton(
                    child: Text(tasks[index]['categoryId']!),
                    style: ElevatedButton.styleFrom(
                      primary: randomColor,
                      elevation: 2,
                      shadowColor: Colors.grey[100]
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
