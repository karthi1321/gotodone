import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsUtils {
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName') ?? 'Guest'; // Fallback to 'Guest'
  }

  static Future<void> setUsername(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
  }

  static Future<bool> getExpandAllState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('expandAllState') ?? true; // Default to true
  }

  static Future<void> setExpandAllState(bool expandAll) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('expandAllState', expandAll);
  }
}
