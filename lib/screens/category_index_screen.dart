
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/providers/category_provider.dart';
import 'package:todoapp/providers/task_provider.dart';
import 'package:todoapp/providers/user_provider.dart';

class CategoryIndexScreen extends StatelessWidget {
  var _usernameLoading = false;
  PageController? _pageController;

  CategoryIndexScreen(this._pageController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.only(
        top: mediaQuery.padding.top + 15,
        bottom: mediaQuery.padding.bottom,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: FaIcon(
                  FontAwesomeIcons.search,
                  color: Colors.grey[500],
                ),
              ),
              IconButton(
                onPressed: () async {
                  _pageController!.jumpToPage(0);
                  // Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.cancel_outlined,
                  color: Colors.grey[500],
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 30,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: FittedBox(
                      child: Text(
                    " List of Categories",
                    // 'hg',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              SizedBox(
                // width: 100,
                height: 23,
                child: ElevatedButton(
                    onPressed: () async {
                      await Provider.of<TaskProvider>(context, listen: false)
                          .getAllTasks();

                      Navigator.of(context).pushNamed('/newCategory');
                    },
                    child: const Text('Create new')),
              )
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ListView(
              children: categoryProvider.categories.map(
                (category) {
                  return Card(
                    child: Text(category.name),
                  );
                },
              ).toList(),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
