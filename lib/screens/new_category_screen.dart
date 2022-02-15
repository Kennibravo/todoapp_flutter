import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/category.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/providers/category_provider.dart';

class NewCategoryScreen extends StatefulWidget {
  const NewCategoryScreen({Key? key}) : super(key: key);

  @override
  State<NewCategoryScreen> createState() => _NewCategoryScreenState();
}

class _NewCategoryScreenState extends State<NewCategoryScreen> {
  final nameController = TextEditingController();

  var defaultCategory = categories[0]['name'].toString();
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  DateTime? selectedDate;

  @override
  void dispose() {
    nameController.dispose();
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
                  controller: nameController,
                  decoration: InputDecoration(
                    // border: InputBorder.none,
                    hintText: 'category name',
                    hintStyle: TextStyle(fontSize: 40, color: Colors.grey[500]),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.new_label),
          onPressed: () {
            addCategory();
            Navigator.of(context).pop();
          },
          backgroundColor: Colors.blue,
          label: const Text('New Category', style: TextStyle(fontSize: 18)),
          heroTag: null,
        ),
      ),
    );
  }

  void addCategory() async {
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    provider.createCategory(nameController.text);
    // .collection('Work');
  }
}
