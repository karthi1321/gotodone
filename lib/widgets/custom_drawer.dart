import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final List<Widget> items;

  const CustomDrawer({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          for (var item in items)
            ListTile(
              title: item,
              onTap: () {
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}
