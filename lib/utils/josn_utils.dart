import 'dart:convert';
import 'package:gitgo/models/code_tip_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class JsonUtils {
  static Future<List<CodeTipModel>> fetchJsonData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      return List<CodeTipModel>.from(jsonData['tips'].map((tip) => CodeTipModel(
            day: tip['day'],
            tip: tip['tip'],
            level: tip['level'],
          )));
    } else {
      throw Exception('Failed to load JSON data: $response');
    }
  }

  static Future<List<CodeTipModel>> loadJsonFromAssets(String filePath) async {
    try {
      String filePath = 'assets/linux_100_days_tips.json';
      String jsonString = await rootBundle.loadString(filePath);

      final parsed = json.decode(jsonString);
      // return [];
      return List<CodeTipModel>.from(parsed['tips'].map((tip) => CodeTipModel(
            day: tip['day'],
            tip: tip['tip'],
            level: tip['level'],
          )));
    } catch (e) {
      print('Error loading JSON file: $e');
      // throw Exception('Failed to load JSON data:');
      return [];
    }
  }
}
