import 'package:shared_preferences/shared_preferences.dart';

class CommandSaveUtils {
  static const String _savedCommandsKey = 'savedCommands';

  /// Loads the saved commands from SharedPreferences
  static Future<Set<String>> loadSavedCommands() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_savedCommandsKey)?.toSet() ?? {};
  }

  /// Toggles the save state of a command and updates SharedPreferences
  static Future<void> toggleSaveCommand(
      {required String title, required Set<String> savedCommands}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (savedCommands.contains(title)) {
      savedCommands.remove(title); // Remove if already saved
    } else {
      savedCommands.add(title); // Add if not saved
    }
    await prefs.setStringList(_savedCommandsKey, savedCommands.toList());
  }
}
