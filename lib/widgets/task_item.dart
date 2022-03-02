import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/category.dart';
import 'package:todoapp/providers/category_provider.dart';
import 'package:todoapp/providers/task_provider.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({Key? key}) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  final List<Color?> colors = [Colors.red[200], Colors.blue[100]];

  final FirebaseAuth auth = FirebaseAuth.instance;
  Future? _tasksFuture;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Color getCategoryColor(String id) {
    var category = categories.firstWhere((cate) => cate['id'] == id);
    return category['color'] as Color;
  }

  Future _getAllTasks() {
    return Provider.of<TaskProvider>(context, listen: false).getAllTasks();
  }

  @override
  void initState() {
    // print('before init state');
    Future.delayed(Duration.zero, () async {
      _tasksFuture = await _getAllTasks();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> tasksStream = firestore
        .collection('tasks')
        .doc(auth.currentUser!.uid)
        .collection('task')
        .orderBy('date', descending: true)
        .snapshots();

    final provider = Provider.of<TaskProvider>(context, listen: false);

    return SizedBox(
        height: 900,
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: tasksStream,
                builder:
                    (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(value: 1),
                    );
                  }

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Scrollbar(
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        children:
                            snapshot.data!.docs.map((DocumentSnapshot doc) {
                          Map<String, dynamic> task =
                              doc.data()! as Map<String, dynamic>;
                          Timestamp date = task['date'];
                          DateTime dt = date.toDate();

                          print(date);
                          // print(task);
                          return GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed(
                                '/viewTask',
                                arguments: {'taskId': doc.id}),
                            child: Card(
                              elevation: 0.3,
                              shadowColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                leading: task['status'] != "completed"
                                    ? IconButton(
                                        padding: const EdgeInsets.all(0),
                                        icon: const Icon(Icons.circle_outlined),
                                        onPressed: () async =>
                                            await provider.changeTaskStatus(
                                                doc.id, 'completed', context),
                                        // updateStatus('completed', doc.id),
                                        iconSize: 35,
                                        color: Colors.red)
                                    : IconButton(
                                        padding: const EdgeInsets.all(0),
                                        icon: const Icon(Icons.check_circle),
                                        iconSize: 35,
                                        color: Colors.green,
                                        onPressed: () async =>
                                            provider.changeTaskStatus(
                                                doc.id, 'pending', context),
                                        // updateStatus('pending', doc.id),
                                      ),
                                title: Text(
                                  task['title']!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontSize: 18),
                                ),
                                subtitle: Row(
                                  children: [
                                    const Icon(Icons.schedule, size: 15),
                                    const SizedBox(width: 5),
                                    Text(
                                      DateFormat.yMMMd()
                                          .add_jm()
                                          .format(dt)
                                          .toString(),
                                      style: const TextStyle(fontSize: 12),
                                    )
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  color: Colors.red,
                                  onPressed: () {
                                    provider.deleteSingleTask(doc.id);

                                    Provider.of<CategoryProvider>(context, listen: false)
                                        .getAllCategories();
                                  },
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }

  void updateStatus(String status, String id) async {
    try {
      firestore
          .collection('tasks')
          .doc(auth.currentUser!.uid)
          .collection('task')
          .doc(id)
          .update({'status': status});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text('Task set to $status!'),
        ),
      );

      // ScaffoldMessenger.of(context).hideCurrentSnackBar();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text('Task cannot be set to $status, something went wrong!'),
        ),
      );
    }
  }

  Future<void> editTask(String id, BuildContext ctx) {
    return showDialog(
        context: ctx,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Editing a Task'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('This is a demo alert dialog.'),
                  Text('Would you like to approve of this message?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Approve'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
