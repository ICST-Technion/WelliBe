import 'package:flutter/material.dart';

import 'package:wellibe_app/assets/wellibe_colors.dart';

String welcomeString = 'שלום,';
String nameString = 'דן לביא';

class TopBar extends StatefulWidget {
  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        color: AppColors.mainYellow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://www.woolha.com/media/2020/03/eevee.png'),
              radius: 40,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                welcomeString,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.right,
              ),
              Text(
                nameString,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
