import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/category.dart';
import 'package:todoapp/models/user.dart';
import 'package:todoapp/providers/category_provider.dart';
import 'package:todoapp/providers/task_provider.dart';
import 'package:todoapp/providers/user_provider.dart';
import 'package:todoapp/screens/new_task_screen.dart';
import 'package:todoapp/widgets/category_item.dart';
import 'package:todoapp/widgets/header_item.dart';
import 'package:todoapp/widgets/task_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserModel? userDetails;
  var _usernameLoading = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero, () async {
    //   setState(() {
    //     _usernameLoading = true;
    //   });
    //   final userProvider = Provider.of<UserProvider>(context, listen: false);
    //   print("${userProvider.userDetail!.userData['username']} is the name");
    //   // await userProvider.getAndSetUserDetails();
    //   // userDetails = userProvider.userDetail;

    //   setState(() {
    //     _usernameLoading = false;
    //   });
    //   // print("the name is ${userDetails!.userData['username']}");
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final FirebaseAuth auth = FirebaseAuth.instance;
    // final provider = Provider.of<CategoryProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // FirebaseFirestore firestore = FirebaseFirestore.instance;

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
                    SizedBox(
                      height: 50,
                      width: mediaQuery.size.width * 0.8,
                      child: FittedBox(
                          child: _usernameLoading
                              ? const SizedBox(
                                  width: 10, height: 20, child: Text('...'))
                              : userProvider.userDetail != null
                                  ? Text(
                                      "What's up, ${userProvider.userDetail!.userData['username']}",
                                      // 'hg',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold),
                                    )
                                  : const Text('')),
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
                        SizedBox(
                          width: 100,
                          height: 23,
                          child: ElevatedButton(
                              onPressed: () async {
                                await Provider.of<TaskProvider>(context,
                                        listen: false)
                                    .getAllTasks();

                                Navigator.of(context).pushNamed('/newCategory');
                              },
                              child: const Text('Create new')),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    CategoryItem(),
                    const SizedBox(height: 20),
                    Text(
                      'TODAY\'S TASKS',
                      style: TextStyle(
                          color: Colors.grey[600], fontWeight: FontWeight.bold),
                    ),
                    // const SizedBox(height: 15),
                    const TaskItem(),
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
          onPressed: () {
            Navigator.of(context).pushNamed('/newTask');

            // .then((value) async {
            //   CategoryItem.categoryFuture =
            //       Provider.of<CategoryProvider>(context, listen: false)
            //           .getAllCategories();

            //   setState(() {});
            // });
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
