import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/category.dart';
import 'package:todoapp/models/user.dart';
import 'package:todoapp/providers/category_provider.dart';
import 'package:todoapp/providers/task_provider.dart';
import 'package:todoapp/providers/user_provider.dart';
import 'package:todoapp/screens/category_index_screen.dart';
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
  PageController? _pageController;
  int _currentIndex = 0;

  UserModel? userDetails;
  var _usernameLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final FirebaseAuth auth = FirebaseAuth.instance;
    // final provider = Provider.of<CategoryProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    // FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: [
          Container(
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

                                    Navigator.of(context)
                                        .pushNamed('/newCategory');
                                  },
                                  child: const Text('Create new')),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        CategoryItem(),
                        const SizedBox(height: 40),
                        
                        // const SizedBox(height: 15),
                        const SingleChildScrollView(child: TaskItem()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          CategoryIndexScreen(_pageController),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            if (categoryProvider.categories.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('You need to create a category first!'),
                  action: SnackBarAction(
                    label: 'Create',
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/newCategory'),
                  ),
                ),
              );

              return;
            }

            setState(() {});
            Navigator.of(context).pushNamed('/newTask').then((value) async {
              final provider =
                  Provider.of<CategoryProvider>(context, listen: false);
              provider.setCategoriesToEmpty();
              provider.getAllCategories();
            });
          },
          child: const Icon(Icons.add, size: 30),
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        backgroundColor: const Color(0xFFfafbfe),
        showElevation: false,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController!.jumpToPage(index);
        },
        curve: Curves.easeIn,
        items: [
          BottomNavyBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Home'),
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.category),
            title: const Text('Category'),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
