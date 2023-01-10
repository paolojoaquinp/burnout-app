import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
           DrawerHeader(
            child: Container(),
            decoration: BoxDecoration(
              color: Colors.amberAccent
            ),
          ),
          CircleAvatar(
              child: Text('hi'),
              backgroundColor: Colors.deepPurple,
              radius: 3.0,
          ),
        ],
      ),
    );
  }
}