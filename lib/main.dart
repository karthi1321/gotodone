import 'package:flutter/material.dart';
import 'package:gotodone/constants/AppColors.dart';
import 'package:gotodone/route/app_routes.dart';
import 'package:gotodone/screens/CustomPageTransitionBuilder.dart';
import 'package:gotodone/screens/SlidePageTransitionBuilder.dart';
import 'package:gotodone/screens/SplashScreen.dart';
import 'package:gotodone/utils/DataCache.dart';

void main() async {
  // Ensures widget binding is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized(); 

  // Load all necessary data before running the app
  await DataCache.loadAllData(); 

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoToDone',
      debugShowCheckedModeBanner: false, // Disable debug banner
      home: SplashScreen(),
      routes: AppRoutes.routes,  // Defined routes for app navigation
      theme: _buildAppTheme(),  // Apply custom global theme
      onGenerateRoute: AppRoutes.onGenerateRoute,  // Handle dynamic routes
    );
  }

  // Custom ThemeData for global theme settings
  ThemeData _buildAppTheme() {
    return ThemeData(
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.blue, // Selected color for items
        unselectedItemColor: Colors.grey, // Unselected color for items
      ),
      // Color Scheme based on a seed color and background color
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue, // Seed color for the scheme
        background: AppColors.backgroundColor, // Custom background color
      ),
      // Progress indicator theme with a custom color
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: Colors.blue, // Custom progress indicator color
      ),
      // Page transition theme for custom transitions across platforms
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CustomPageTransitionBuilder(),
          TargetPlatform.iOS: CustomPageTransitionBuilder(),
          TargetPlatform.fuchsia: CustomPageTransitionBuilder(),
        },
      ),
    );
  }
}
