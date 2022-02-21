import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ViewTaskScreen extends StatelessWidget {
  const ViewTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 17),
        padding: EdgeInsets.only(
          top: mediaQuery.padding.top + 15,
          bottom: mediaQuery.padding.bottom + 15,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    foregroundColor: Colors.grey,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: const [
                    Icon(Icons.topic_rounded, size: 20),
                    SizedBox(width: 15),
                    Text('This is the fucking title',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: const [
                    FaIcon(FontAwesomeIcons.infoCircle, size: 20),
                    SizedBox(width: 15),
                    Flexible(
                      child: Text(
                        'This is the fucking body, see how it fucking looks like right dfd dfdf fdfd fdf dre ger here',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.calendar, size: 20),
                    const SizedBox(width: 15),
                    Stack(
                      children: [
                        SizedBox(
                          width: 180,
                          height: 40,
                          child: OutlinedButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.all(12)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black)),
                            onPressed: () {},
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                DateFormat.yMMMEd().format(DateTime.now()),
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -3.5,
                          right: 0,
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.cancel_outlined)),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            Column(
              children: [
                const Divider(),
                Container(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    style: TextButton.styleFrom(primary: Colors.black),
                    onPressed: () {},
                    child: const ListTile(
                      leading: Icon(Icons.done),
                      title: Text('Mark as completed',
                          style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
    // ),
  }
}
