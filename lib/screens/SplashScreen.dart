import 'package:flutter/material.dart';
import 'package:gitgo/screens/username_Input_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gitgo/screens/persistent_bottom_nav.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  Future<void> _startSplashScreen() async {
    // Always wait for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final String? userName = prefs.getString('userName');

    if (userName != null && userName.isNotEmpty) {
      // Navigate to PersistentBottomNav if username exists
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PersistentBottomNav()),
        );
      }
    } else {
      // Navigate to UsernameInputPage if username doesn't exist
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UsernameInputPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
                children: [
                  TextSpan(
                    text: 'Git',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(
                    text: 'Go',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Simple and Smart.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
