import 'package:shared_preferences/shared_preferences.dart';

class TTSSettingsManager {
  static late SharedPreferences _prefs;
  static String language = 'en-US';
  static double pitch = 1.0;
  static double speechRate = 1.0;

  /// Initialize SharedPreferences and load saved settings
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    language = _prefs.getString('language') ?? 'en-US';
    pitch = _prefs.getDouble('pitch') ?? 1.0;
    speechRate = _prefs.getDouble('speechRate') ?? 1.0;
  }

  /// Update and save new settings to SharedPreferences
  static Future<void> updateSettings({
    required String newLanguage,
    required double newPitch,
    required double newRate,
  }) async {
    language = newLanguage;
    pitch = newPitch;
    speechRate = newRate;
    await _prefs.setString('language', language);
    await _prefs.setDouble('pitch', pitch);
    await _prefs.setDouble('speechRate', speechRate);
  }
}
