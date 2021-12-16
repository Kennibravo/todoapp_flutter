import 'package:flutter/material.dart';
import 'package:todoapp/widgets/category_item.dart';
import 'package:todoapp/widgets/header_item.dart';
import 'package:todoapp/widgets/task_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: mediaQuery.padding.top + 15,
          bottom: mediaQuery.padding.bottom + 15,
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
                        'What\'s up, Kenny!',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'CATEGORIES',
                      style: TextStyle(
                          color: Colors.grey[600], fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    const CategoryItem(),
                    const SizedBox(height: 20),
                    Text(
                      'TODAY\'S TASKS',
                      style: TextStyle(
                          color: Colors.grey[600], fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    TaskItem(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
