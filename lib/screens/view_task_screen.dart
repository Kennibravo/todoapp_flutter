import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/providers/task_provider.dart';

class ViewTaskScreen extends StatefulWidget {
  const ViewTaskScreen({Key? key}) : super(key: key);

  @override
  State<ViewTaskScreen> createState() => _ViewTaskScreenState();
}

class _ViewTaskScreenState extends State<ViewTaskScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final provider = Provider.of<TaskProvider>(context);

    final task = provider.getSingleTask(args['taskId']!);

    return Scaffold(
      body: Container(
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
                      task.title,
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
                        task.content,
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
                        task.category.name,
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
                                DateFormat.yMMMEd().format(task.date),
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
                  child: task.status == 'completed'
                      ? TextButton(
                          style: TextButton.styleFrom(primary: Colors.black),
                          onPressed: () async =>
                              await provider.changeTaskStatus(
                            task.id,
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
                          style: TextButton.styleFrom(primary: Colors.black),
                          onPressed: () async =>
                              await provider.changeTaskStatus(
                            task.id,
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
