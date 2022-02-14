ListView.builder(
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        // shrinkWrap: true,
        itemCount: tasks.length,
        itemBuilder: (ctx, index) {
          return Card(
            elevation: 0.3,
            shadowColor: Colors.grey[200],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: tasks[index]['status'] != "completed"
                  ? IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.circle_outlined),
                      onPressed: () {},
                      iconSize: 35,
                      color: getCategoryColor(tasks[index]['categoryId']!),
                    )
                  : IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: const Icon(Icons.check_circle),
                      iconSize: 35,
                      color: getCategoryColor(tasks[index]['categoryId']!),
                      onPressed: () {},
                    ),
              title: Text(
                tasks[index]['title']!,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 18),
              ),
              // trailing: Container(
              //   height: 20,
              //   child: ElevatedButton(
              //     child: Text(tasks[index]['categoryId']!),
              //     style: ElevatedButton.styleFrom(
              //         primary: randomColor,
              //         elevation: 2,
              //         shadowColor: Colors.grey[100]),
              //     onPressed: () {},
              //   ),
              // ),
            ),
          );
        },
      ),