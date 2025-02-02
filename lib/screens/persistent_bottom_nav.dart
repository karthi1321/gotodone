import 'package:flutter/material.dart';
import 'package:gotodone/constants/app_constants.dart';
import 'package:gotodone/screens/TaskSearchDelegate.dart';
import 'package:gotodone/screens/TextSpeechSettings.dart';
import 'package:gotodone/screens/commands_list_page.dart';
import 'package:gotodone/screens/explain_page.dart';
import 'package:gotodone/screens/explore_page.dart';
import 'package:gotodone/screens/python_basic.dart';
import 'package:gotodone/screens/roadmap_page.dart';
import 'package:gotodone/screens/saved_commands_page.dart';
import 'package:gotodone/screens/todo_list_page.dart';
import 'landing_page.dart';
import 'temp/LessonScreen.dart';

class PersistentBottomNav extends StatefulWidget {
  @override
  _PersistentBottomNavState createState() => _PersistentBottomNavState();
}

class _PersistentBottomNavState extends State<PersistentBottomNav> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    LandingPage(),
    TodoListPage(),
    //  Center(child: Text('Notifications Page')), // Placeholder for notifications
    // Center(child: Text('Profile Page')),       // Placeholder for profile
    CommandsListPage(groupKey: RoadmapItems.all),

    // ExplainPage(topic: "ok", group: '',),
    // BookPageEffect(),
    TaskSearchPage()
    // TodoListPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index); // Navigate to selected page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), // Disable swipe gestures
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Tasks',
          ),
         
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'important',
          ),
        ],
      ),
    );
  }
}
