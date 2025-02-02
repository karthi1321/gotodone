import 'package:flutter/material.dart';
import 'package:gitgo/constants/app_constants.dart';
import 'package:gitgo/screens/TextSpeechSettings.dart';
import 'package:gitgo/screens/explain_page.dart';
import 'package:gitgo/screens/explore_page.dart';
import 'package:gitgo/screens/python_basic.dart';
import 'package:gitgo/screens/python_list_view.dart';
import 'package:gitgo/screens/roadmap_page.dart';
import 'package:gitgo/screens/commands_list_page.dart';

class AppRoutes {
  // Static routes for pages without dynamic arguments
  static Map<String, WidgetBuilder> routes = {
    '/pythonBasicsRoadmap': (context) => PythonBasicsRoadmapPage(),
    '/roadmapPage': (context) => RoadmapPage(
          title: 'Git Roadmap',
          roadmapItems: RoadmapItems.gitBasics,
        ),
    '/textSpeechSettings': (context) => TextSpeechSettings(),
    '/explore': (context) => ExplorePage(), // Fixed typo here
    '/dailyTips': (context) => PythonListView()
    // '/explain': (context) => ExplainPage(
    //       topic: 'Ok',
    //       group: 'basic',
    //     ),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/sessionPage':
        final args = settings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              CommandsListPage(groupKey: args['groupKey']),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); // Start from the right
            const end = Offset.zero; // End at the center
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
      case '/explain':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => ExplainPage( topic: args['topic'],group: args['group']),
        );

      default:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
            body: Center(child: Text('Page not found')),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var opacityTween = Tween(begin: 0.0, end: 1.0);
            var fadeAnimation = animation.drive(opacityTween);
            return FadeTransition(opacity: fadeAnimation, child: child);
          },
        );
    }
  }
}
