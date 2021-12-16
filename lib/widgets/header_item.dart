import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HeaderItem extends StatelessWidget {
  const HeaderItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, right: 15, left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: FaIcon(
              FontAwesomeIcons.bars,
              color: Colors.grey[500],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: FaIcon(
                  FontAwesomeIcons.search,
                  color: Colors.grey[500],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: FaIcon(
                  FontAwesomeIcons.bell,
                  color: Colors.grey[500],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
