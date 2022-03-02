import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/category.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/providers/task_provider.dart';

class ViewTaskScreen extends StatefulWidget {
  const ViewTaskScreen({Key? key}) : super(key: key);

  @override
  State<ViewTaskScreen> createState() => _ViewTaskScreenState();
}

class _ViewTaskScreenState extends State<ViewTaskScreen> {
  var isLoadedTasks = false;

  var _task = Task(
      id: '',
      title: '',
      content: '',
      category: Category('DS', '43', DateTime.now(), 5),
      status: '',
      date: DateTime.now());

  @override
  void initState() {
    isLoadedTasks = false;

    Future.delayed(Duration.zero, () async {
      final provider = Provider.of<TaskProvider>(context, listen: false);
      await provider.getAllTasks();

      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;

      setState(() {
        _task = provider.getSingleTask(args['taskId']!);
        isLoadedTasks = true;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      body: !isLoadedTasks
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 17),
              padding: EdgeInsets.only(
                top: mediaQuery.padding.top + 15,
                bottom: mediaQuery.padding.bottom + 15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          foregroundColor: Colors.grey,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.cancel_outlined,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          const Icon(Icons.topic_rounded, size: 20),
                          const SizedBox(width: 15),
                          Text(
                            // 'ds',
                            _task.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.infoCircle, size: 20),
                          const SizedBox(width: 15),
                          Flexible(
                            child: Text(
                              _task.content,
                              // 'This is the fucking body, see how it fucking looks like right dfd dfdf fdfd fdf dre ger here',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Icon(Icons.category, size: 20),
                          const SizedBox(width: 15),
                          Flexible(
                            child: Text(
                              _task.category.name,
                              // 'This is the fucking body, see how it fucking looks like right dfd dfdf fdfd fdf dre ger here',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.calendar, size: 20),
                          const SizedBox(width: 15),
                          Stack(
                            children: [
                              SizedBox(
                                width: 180,
                                height: 40,
                                child: OutlinedButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.all(12)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black)),
                                  onPressed: () {},
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      DateFormat.yMMMEd().format(_task.date),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -3.5,
                                right: 0,
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.cancel_outlined)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Divider(),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: _task.status == 'completed'
                            ? TextButton(
                                style:
                                    TextButton.styleFrom(primary: Colors.black),
                                onPressed: () async =>
                                    await provider.changeTaskStatus(
                                  _task.id,
                                  'pending',
                                  context,
                                ),
                                child: const ListTile(
                                  leading: Icon(Icons.pending),
                                  title: Text('Mark as pending',
                                      style: TextStyle(fontSize: 20)),
                                ),
                              )
                            : TextButton(
                                style:
                                    TextButton.styleFrom(primary: Colors.black),
                                onPressed: () async =>
                                    await provider.changeTaskStatus(
                                  _task.id,
                                  'completed',
                                  context,
                                ),
                                child: const ListTile(
                                  leading: Icon(Icons.pending),
                                  title: Text('Mark as completed',
                                      style: TextStyle(fontSize: 20)),
                                ),
                              ),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
    // ),
  }
}
