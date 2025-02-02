import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  Color primaryColor = Colors.blue;
  Color backgroundColor = Colors.white;

  void updateTheme({
    required Color primaryColor,
    required Color backgroundColor,
  }) {
    this.primaryColor = primaryColor;
    this.backgroundColor = backgroundColor;
    notifyListeners();
  }
}
