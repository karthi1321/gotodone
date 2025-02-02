import 'package:flutter/material.dart';
import 'package:gitgo/screens/commands_search_page.dart';
 
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(int) onIconSelected;

  CustomAppBar({required this.onIconSelected});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  int _selectedIndex = 0;

  void _selectIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onIconSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: const TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            children: <TextSpan>[
              TextSpan(text: 'Git', style: TextStyle(color: Colors.red)),
              // TextSpan(text: ' '),
              TextSpan(text: 'Go', style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
      ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          color: _selectedIndex == 0 ? Colors.blue : Colors.black,
          onPressed: () {
            _selectIndex(0);
            // Navigate to the search page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CommandsSearchPage()),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.menu),
          color: _selectedIndex == 2 ? Colors.blue : Colors.black,
          onPressed: () {
            _selectIndex(2);
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }
}
