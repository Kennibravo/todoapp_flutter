import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/category.dart';
import 'package:todoapp/providers/category_provider.dart';
import 'package:todoapp/screens/new_task_screen.dart';
import 'package:todoapp/widgets/category_item.dart';
import 'package:todoapp/widgets/header_item.dart';
import 'package:todoapp/widgets/task_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final provider = Provider.of<CategoryProvider>(context, listen: false);

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: mediaQuery.padding.top + 15,
          bottom: mediaQuery.padding.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderItem(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        'What\'s up, ${auth.currentUser!.displayName}!',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(
                                fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CATEGORIES: ',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 100,
                          height: 23,
                          child: ElevatedButton(
                              onPressed: () {
                                // await provider.getAllCategories();
                                // print(provider.categories[0].name);

                                // final allCategories = await firestore
                                //     .collection('users')
                                //     .doc('YeNHB2iN3WUffwNQi5SgxtpydDC2')
                                //     .collection('categories')
                                //     .doc('Ewfchzhju4DkjaaETpW2')
                                //     // .collection('Business')
                                //     .get();

                                // print(allCategories.map((c) => c.data()).toList());
                                // .doc(auth.currentUser!.uid).get();

                                //     .doc(auth.currentUser!.uid)
                                // final category = await firestore
                                //     .collection('users_new')
                                //     .doc(auth.currentUser!.uid)
                                //     .collection('Business')
                                //     .add({'name': 'Shopping'});
                                //     .collection('Work');

                                // await firestore
                                //     .collection('users_new')
                                //     .doc(auth.currentUser!.uid)
                                //     .collection('Business')
                                //     .doc('pwKbAPobC53AaccO6oq9')
                                //     .collection('tasks')
                                //     .add({
                                //   'title': "addeddd",
                                //   'content': 'addedddd too'
                                // });
                                // category.collection('tasks')

                                Navigator.of(context)
                                    .pushNamed('/newCategory');
                              },
                              child: const Text('Create new')),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    const CategoryItem(),
                    const SizedBox(height: 20),
                    Text(
                      'TODAY\'S TASKS',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold),
                    ),
                    // const SizedBox(height: 15),
                    TaskItem(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          heroTag: 'newTask',
          backgroundColor: Colors.blue,
          onPressed: () async {
            final userDetails = await firestore
                .collection('users')
                .doc(auth.currentUser!.uid)
                .get();

            final String username = ('users.${userDetails['username']}');

            final category = await firestore
                .collection('categories')
                .where(username, isEqualTo: true)
                .get();

            print(category.docs.map((e) => e.data()).toList());
            Navigator.of(context).pushNamed('/newTask');
          },
          child: const Icon(Icons.add, size: 30),
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
          backgroundColor: null,
          showElevation: true,
          itemCornerRadius: 24,
          curve: Curves.easeIn,
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.category),
              title: Text('Category'),
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.history),
              title: Text('History'),
              textAlign: TextAlign.center,
            ),
          ],
          onItemSelected: (page) {}),
    );
  }
}
