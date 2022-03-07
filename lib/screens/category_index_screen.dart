import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/providers/category_provider.dart';
import 'package:todoapp/providers/task_provider.dart';
import 'package:todoapp/providers/user_provider.dart';

class CategoryIndexScreen extends StatefulWidget {
  PageController? _pageController;

  CategoryIndexScreen(this._pageController, {Key? key}) : super(key: key);

  @override
  State<CategoryIndexScreen> createState() => _CategoryIndexScreenState();
}

class _CategoryIndexScreenState extends State<CategoryIndexScreen> {
  var _usernameLoading = false;
  // AsyncMemoizer? _memoizer;

  @override
  void initState() {
    // _memoizer = AsyncMemoizer();
    super.initState();
  }

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
                  widget._pageController!.jumpToPage(0);
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
          categoryProvider.categories.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: mediaQuery.size.width * 0.8,
                      child: Image.asset('images/empty.png'),
                    ),
                    const Text('There is no task in this category'),
                  ],
                )
              : Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    children: categoryProvider.categories.map(
                      (category) {
                        return SizedBox(
                          height: 70,
                          child: Card(
                            child: ListTile(
                              title: Text(category.name),
                              trailing:
                                  const Icon(Icons.delete, color: Colors.red),
                              subtitle: Text(DateFormat.yMMMEd()
                                  .format(category.createdAt)),
                            ),
                          ),
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
