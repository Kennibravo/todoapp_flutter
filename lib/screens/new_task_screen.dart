import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/models/category.dart';
import 'package:intl/intl.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  var defaultCategory = categories[0]['name'].toString();
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime? selectedDate;

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Hero(
      tag: 'newTask',
      child: Scaffold(
        body: Container(
          // color: Colors.red,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.only(
            top: mediaQuery.padding.top + 15,
            bottom: mediaQuery.padding.bottom + 15,
          ),
          child: SingleChildScrollView(
            child: Column(
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
                const SizedBox(height: 180),
                TextField(
                  style: const TextStyle(fontSize: 40),
                  autofocus: true,
                  controller: titleController,
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    hintText: 'enter new task',
                    hintStyle: TextStyle(fontSize: 40, color: Colors.grey[500]),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  maxLines: 3,
                  style: const TextStyle(fontSize: 40),
                  autofocus: true,
                  keyboardType: TextInputType.multiline,
                  controller: contentController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'enter content',
                    hintStyle: TextStyle(fontSize: 40, color: Colors.grey[500]),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.date_range_rounded),
                      label: Text(
                        'Date Selected',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      selectedDate == null
                          ? 'No date selected'
                          : DateFormat.yMMMEd().format(selectedDate!),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        primary: Colors.white,
                        onPrimary: Color.fromARGB(255, 122, 48, 48),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 6),
                      ),
                      onPressed: () {
                        showTaskDatePicker();
                      },
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: const Text(
                        'Today',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Container(
                      width: 150,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      child: DropdownButton(
                        elevation: 0,
                        value: defaultCategory,
                        borderRadius: BorderRadius.circular(20),
                        items: categories.map((Map<String, Object?> items) {
                          return DropdownMenuItem(
                            value: items['name'],
                            child: Text(items['name'].toString()),
                          );
                        }).toList(),
                        onChanged: (item) {
                          setState(() {
                            defaultCategory = item.toString();
                            print(defaultCategory);
                          });
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.new_label),
          onPressed: () {
            addTask();
            Navigator.of(context).pop();
          },
          backgroundColor: Colors.blue,
          label: const Text('New task', style: TextStyle(fontSize: 18)),
          heroTag: null,
        ),
      ),
    );
  }

  void showTaskDatePicker() async {
    if (Platform.isIOS) {
      showModalBottomSheet(
        context: context,
        builder: (ctx) => Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (date) {
              setState(() {
                selectedDate = date;
                print(selectedDate);
              });
            },
            initialDateTime: selectedDate,
            minimumYear: DateTime.now().year,
            maximumYear: DateTime.now().year,
          ),
        ),
      );
    } else {
      final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025),
      );

      setState(() {
        selectedDate = date;
        print(selectedDate);
      });
    }
  }

  void addTask() async {
    final doc = firestore.collection('users').doc(auth.currentUser!.uid);

    try {
      await doc.collection('tasks').add({
        'title': titleController.text,
        'content': contentController.text,
        'date': selectedDate!.toIso8601String(),
        'status': (selectedDate != DateTime.now() ? 'pending' : 'completed'),
      });

      print("Added task");
    } catch (e) {
      print(e);
    }
  }
}