import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/category.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/providers/category_provider.dart';
import 'package:todoapp/providers/task_provider.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  // var defaultCategory = categories[0]['name'].toString();
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? defaultCategory;

  DateTime? selectedDate;

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    defaultCategory = Provider.of<CategoryProvider>(context, listen: false)
        .categories[0]
        .name;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    // final defaultCategory = provider.categories[1].name;

    String? selectedCategory;

    return Scaffold(
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
              const SizedBox(height: 120),
              TextField(
                style: const TextStyle(fontSize: 40),
                // autofocus: true,
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
                // autofocus: true,
                keyboardType: TextInputType.multiline,
                controller: contentController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'enter content',
                  hintStyle: TextStyle(fontSize: 40, color: Colors.grey[500]),
                ),
              ),
              const SizedBox(height: 10),
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'd MMM, yyyy',
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                dateLabelText: 'Date',
                timeLabelText: "Time",
                onChanged: (str) {
                  setState(() {
                    selectedDate = DateTime.parse(str);
                  });
                },
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.category),
                      label: const Text(
                        'Category',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    width: 150,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 10),
                    child: DropdownButton(
                      value: defaultCategory,
                      borderRadius: BorderRadius.circular(20),
                      items: provider.categories
                          .map(
                            (items) => DropdownMenuItem(
                              value: items.name,
                              child: Text(items.name.toString()),
                            ),
                          )
                          .toList(),
                      onChanged: (item) {
                        setState(() {
                          defaultCategory = item.toString();
                          // print(selectedCategory);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.new_label),
        onPressed: () async {
          await addTask(defaultCategory!);
          
          Navigator.of(context).pop();
        },
        backgroundColor: Colors.blue,
        label: const Text('New task', style: TextStyle(fontSize: 18)),
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

  Future<void> addTask(String categoryName) async {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);

    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    final category = categoryProvider.categories
        .firstWhere((category) => category.name == categoryName);

    await taskProvider.addTask(
      title: titleController.text,
      content: contentController.text,
      category: category,
      date: selectedDate ?? DateTime.now(),
    );

    final event = Event(
      title: titleController.text,
      description: contentController.text,
      startDate: selectedDate!,
      endDate: DateTime.now(),
    );

    await Add2Calendar.addEvent2Cal(event);
  }
}
