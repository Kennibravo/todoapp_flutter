import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/category.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/providers/category_provider.dart';
import 'package:todoapp/providers/task_provider.dart';
import 'package:todoapp/widgets/header_item.dart';

class CategoryTasksScreen extends StatefulWidget {
  const CategoryTasksScreen({Key? key}) : super(key: key);

  @override
  State<CategoryTasksScreen> createState() => _CategoryTasksScreenState();
}

class _CategoryTasksScreenState extends State<CategoryTasksScreen> {
  List<Task> _tasks = [];
  var _isLoadingTasks = false;

  @override
  void didChangeDependencies() {
    _isLoadingTasks = true;

    Future.delayed(Duration.zero, () async {
      final args = ModalRoute.of(context)!.settings.arguments as Category;
      final provider = Provider.of<TaskProvider>(context, listen: false);
      await provider.getAllTasks();

      setState(() {
        _tasks = provider.getAllTasksFromCategory(args);
        _isLoadingTasks = false;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);
    final mediaQuery = MediaQuery.of(context);
    final args = ModalRoute.of(context)!.settings.arguments as Category;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: mediaQuery.padding.top + 15,
          bottom: mediaQuery.padding.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin:
                      const EdgeInsets.only(bottom: 20, right: 15, left: 15),
                  child: Row(
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
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.cancel_outlined,
                          color: Colors.grey[500],
                          size: 32,
                        ),
                      ),
                    ],
                  )),
              _isLoadingTasks
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 15),

                          alignment: Alignment.topLeft,
                          height: 40,
                          // width: mediaQuery.size.width * 0.8,
                          child: FittedBox(
                              child: Text(
                            " Tasks in ${args.name} category",
                            // 'hg',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 22),
                          alignment: Alignment.topRight,
                          child: Text('${_tasks.length} tasks'),
                        ),
                        _tasks.isEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: mediaQuery.size.width * 0.8,
                                    child: Image.asset('images/empty.png'),
                                  ),
                                  const Text(
                                      'There is no task in this category'),
                                ],
                              )
                            : Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: SizedBox(
                                  height: mediaQuery.size.height * 0.8,
                                  child: ListView.builder(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 0),
                                    itemCount: _tasks.length,
                                    itemBuilder: (ctx, index) {
                                      print(_tasks.length);
                                      DateTime dt = _tasks[index].date;

                                      return GestureDetector(
                                        child: Card(
                                          elevation: 0.3,
                                          shadowColor: Colors.grey[200],
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: ListTile(
                                            leading: _tasks[index].status !=
                                                    "completed"
                                                ? IconButton(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    icon: const Icon(
                                                        Icons.circle_outlined),
                                                    onPressed: () async =>
                                                        await provider
                                                            .changeTaskStatus(
                                                                _tasks[index]
                                                                    .id,
                                                                'completed',
                                                                context),
                                                    // updateStatus('completed', doc.id),
                                                    iconSize: 35,
                                                    color: Colors.red)
                                                : IconButton(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    icon: const Icon(
                                                        Icons.check_circle),
                                                    iconSize: 35,
                                                    color: Colors.green,
                                                    onPressed: () async =>
                                                        provider
                                                            .changeTaskStatus(
                                                                _tasks[index]
                                                                    .id,
                                                                'pending',
                                                                context),
                                                    // updateStatus('pending', doc.id),
                                                  ),
                                            title: Text(
                                              _tasks[index].title,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(fontSize: 18),
                                            ),
                                            subtitle: Row(
                                              children: [
                                                const Icon(Icons.schedule,
                                                    size: 15),
                                                const SizedBox(width: 5),
                                                Text(
                                                  DateFormat.yMMMd()
                                                      .add_jm()
                                                      .format(dt)
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                )
                                              ],
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(
                                                  Icons.delete_outline),
                                              color: Colors.red,
                                              onPressed: () {
                                                Provider.of<TaskProvider>(
                                                        context,
                                                        listen: false)
                                                    .deleteSingleTask(
                                                        _tasks[index].id);

                                                final provider = Provider.of<
                                                        CategoryProvider>(
                                                    context,
                                                    listen: false);

                                                provider.setCategoriesToEmpty();

                                                provider.getAllCategories();
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
