// ignore: file_names
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color.fromARGB(255, 176, 62, 16);
static const Color backgroundColor = Color(0xFFEFF7F6); // Soft teal

  static const String assetsPath = 'assets/data';

  static String getAssetPath(String filePath) {
    return '$assetsPath/$filePath';
  }
}
