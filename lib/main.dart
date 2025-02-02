import 'package:flutter/material.dart';
import 'package:gitgo/constants/AppColors.dart';
import 'package:gitgo/route/app_routes.dart';
import 'package:gitgo/screens/CustomPageTransitionBuilder.dart';
import 'package:gitgo/screens/SlidePageTransitionBuilder.dart';
import 'package:gitgo/screens/SplashScreen.dart';
import 'package:gitgo/utils/DataCache.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await DataCache.loadAllData(); // Load all data before running the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'gitgo',
      routes: AppRoutes.routes,
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          background: AppColors.backgroundColor,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.blue,
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
            TargetPlatform.iOS: CustomPageTransitionBuilder(),
            TargetPlatform.fuchsia: CustomPageTransitionBuilder(),
          },
        ),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRoutes.onGenerateRoute, // For dynamic routes
    );
  }
}
