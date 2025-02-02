import 'package:flutter/material.dart';
import 'package:gotodone/constants/AppColors.dart';
import 'package:gotodone/route/app_routes.dart';
import 'package:gotodone/screens/CustomPageTransitionBuilder.dart';
import 'package:gotodone/screens/SlidePageTransitionBuilder.dart';
import 'package:gotodone/screens/SplashScreen.dart';
import 'package:gotodone/utils/DataCache.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await DataCache.loadAllData(); // Load all data before running the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'gotodone',
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
