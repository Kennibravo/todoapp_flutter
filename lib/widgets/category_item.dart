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

  @override
  void initState() {
    Provider.of<CategoryProvider>(context, listen: false)
        .getAllCategories()
        .then(
          (value) => Future.delayed(
            const Duration(milliseconds: 500),
            () {
              setState(() {
                cardWidth = 300 * 0.5;
              });
            },
          ),
        );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final provider = Provider.of<CategoryProvider>(context);

    return provider.categories.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                CircularProgressIndicator(),
                Text('Fetching all categories, please wait...')
              ],
            ),
          )
        : SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: provider.categories.length,
              itemBuilder: (ctx, index) {
                
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
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${provider.categories[index].numberOfTasks} tasks',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 15),
                          ),
                          Text(
                            provider.categories[index].name,
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
                                width: cardWidth,
                                height: 5,
                                color: categories[index]['color'] as Color,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     setState(() {});
                          //   },
                          //   child: Text('Text'),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
