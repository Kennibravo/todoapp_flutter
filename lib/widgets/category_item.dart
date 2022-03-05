import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/category.dart';
import 'package:todoapp/providers/category_provider.dart';

class CategoryItem extends StatefulWidget {
  CategoryItem({Key? key}) : super(key: key);

  static Future? categoryFuture;

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  Future? _categoryFuture;

  Future _getAllCategories() {
    return Provider.of<CategoryProvider>(context, listen: false)
        .getAllCategories();
  }

  double cardWidth = 0;
  int taskLength = 1;
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    print('logger: in initSTate');
    _categoryFuture = _getAllCategories();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('logger: In didchangedepen');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Consumer<CategoryProvider>(
      builder: (ctx, categoryData, _) {
        if (categoryData.categories.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return FutureBuilder(
            future: _categoryFuture,
            builder: (context, snapshot) {
              print('logger: in future builder');

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Fetching all categories, please wait...')
                    ],
                  ),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Sorry, we could not get any category right now, try creating one.',
                  ),
                );
              }
              return SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryData.categories.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).pushNamed(
                          '/categoryTasksScreen',
                          arguments: categoryData.categories[index]),
                          
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: 60,
                        width: mediaQuery.size.width * 0.6,
                        child: Card(
                          elevation: 0.8,
                          shadowColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${categoryData.categories[index].numberOfTasks} tasks',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 15),
                                ),
                                Text(
                                  categoryData.categories[index].name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),
                                Stack(
                                  children: [
                                    Container(
                                      width: 300,
                                      height: 5,
                                      color: Colors.grey[300],
                                    ),
                                    AnimatedContainer(
                                        curve: Curves.linear,
                                        duration: const Duration(seconds: 1),
                                        width: (categoryData.categories[index]
                                                    .numberOfTasks !=
                                                0)
                                            ? cardWidth *
                                                    (categoryData
                                                            .categories[index]
                                                            .numberOfTasks /
                                                        300) +
                                                20
                                            : 0,
                                        height: 5,
                                        color: Colors.red),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            });
      },
    );
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> categoryStream() async {
    final userDetails =
        await firestore.collection('users').doc(auth.currentUser!.uid).get();

    final String username = ('users.${userDetails['username']}');

    return firestore
        .collection('categories')
        .where(username, isEqualTo: true)
        .snapshots();

    // final String username = ('users.${userDetails['username']}');
  }
}
