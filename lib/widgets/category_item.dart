import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/category.dart';
import 'package:todoapp/providers/category_provider.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({Key? key}) : super(key: key);

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  double cardWidth = 0;
  int taskLength = 1;
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // Provider.of<CategoryProvider>(context, listen: false)
    //     .getAllCategories()
    //     .then(
    //       (value) => Future.delayed(
    //         const Duration(milliseconds: 500),
    //         () {
    //           setState(() {
    //             cardWidth = 300 * double.parse(taskLength.toString());
    //           });
    //         },
    //       ),
    //     );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final provider = Provider.of<CategoryProvider>(context);

    return FutureBuilder(
        future: categoryStream(),
        builder: (BuildContext ct, AsyncSnapshot snapshot) {
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

          print('The Future');
          var future =
              snapshot.data as Stream<QuerySnapshot<Map<String, dynamic>>>;

          return StreamBuilder(
            stream: future,
            builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something went wrong'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Text('Loading...'));
              }
              print('The Stream');

              return SizedBox(
                  height: 150,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      // itemCount: provider.categories.length,
                      children: snapshot.data!.docs.map((DocumentSnapshot doc) {
                        Map<String, dynamic> category =
                            doc.data()! as Map<String, dynamic>;

                        return Container(
                          margin: const EdgeInsets.only(right: 10),
                          height: 60,
                          width: mediaQuery.size.width * 0.6,
                          child: Card(
                            elevation: 0.8,
                            shadowColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // Text(
                                  //   '${provider.categories[index].numberOfTasks} tasks',
                                  //   style: TextStyle(
                                  //       color: Colors.grey[600], fontSize: 15),
                                  // ),
                                  Text(
                                    category['name'],
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
                                          // width: (provider.categories[index]
                                          //             .numberOfTasks !=
                                          //         0)
                                          //     ? cardWidth *
                                          //             (provider.categories[index]
                                          //                     .numberOfTasks /
                                          //                 300) +
                                          //         20
                                          //     : 0,
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
                        );
                      }).toList()));
            },
          );
        });

    // return provider.categories.isEmpty
    //     ? Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: const [
    //             CircularProgressIndicator(),
    //             SizedBox(height: 20),
    //             Text('Fetching all categories, please wait...')
    //           ],
    //         ),
    //       )
    //     : SizedBox(
    //         height: 150,
    //         child: ListView.builder(
    //           scrollDirection: Axis.horizontal,
    //           itemCount: provider.categories.length,
    //           itemBuilder: (ctx, index) {
    //             return Container(
    //               margin: const EdgeInsets.only(right: 10),
    //               height: 60,
    //               width: mediaQuery.size.width * 0.6,
    //               child: Card(
    //                 elevation: 0.8,
    //                 shadowColor: Colors.grey[200],
    //                 shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(10)),
    //                 child: Container(
    //                   margin: const EdgeInsets.symmetric(horizontal: 15),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     mainAxisAlignment: MainAxisAlignment.end,
    //                     children: [
    //                       Text(
    //                         '${provider.categories[index].numberOfTasks} tasks',
    //                         style: TextStyle(
    //                             color: Colors.grey[600], fontSize: 15),
    //                       ),
    //                       Text(
    //                         provider.categories[index].name,
    //                         style: Theme.of(context)
    //                             .textTheme
    //                             .headline5!
    //                             .copyWith(fontWeight: FontWeight.bold),
    //                       ),
    //                       const SizedBox(height: 20),
    //                       Stack(
    //                         children: [
    //                           Container(
    //                             width: 300,
    //                             height: 5,
    //                             color: Colors.grey[300],
    //                           ),
    //                           AnimatedContainer(
    //                               curve: Curves.linear,
    //                               duration: const Duration(seconds: 1),
    //                               width: (provider.categories[index]
    //                                           .numberOfTasks !=
    //                                       0)
    //                                   ? cardWidth *
    //                                           (provider.categories[index]
    //                                                   .numberOfTasks /
    //                                               300) +
    //                                       20
    //                                   : 0,
    //                               height: 5,
    //                               color: Colors.red),
    //                         ],
    //                       ),
    //                       const SizedBox(
    //                         height: 20,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             );
    //           },
    //         ),
    //       );
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
