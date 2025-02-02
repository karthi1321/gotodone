import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gotodone/constants/app_constants.dart';

class DataCache {
  static final List<Map<String, dynamic>> _dataCache = [];

  /// Load data from multiple JSON files into memory
  static Future<void> loadAllData() async {
    try {
      final List<String> jsonFiles = [
        // "assets/content/basic.json",
        "assets/content/branch_management.json",
        "assets/content/remote_management.json",
        "assets/content/undo_changes.json",
        "assets/content/tagging.json",
        "assets/content/viewing_logs.json",
        "assets/content/collaboration.json"
      ];

      for (String file in jsonFiles) {
        final String response = await rootBundle.loadString(file);
        final List<dynamic> jsonData = json.decode(response);
        // print( "dddllllllllllllllllllllllllllll*************999999999999)");
        // print(jsonData);
        _dataCache.addAll(jsonData.cast<Map<String, dynamic>>());
      }
      print('Data loaded successfully. Total items: ${_dataCache.length}');
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  // Load data from multiple JSON files into memory
  static Future<void> loadDetailSessionData() async {
    try {
      final List<String> jsonFiles = [
        "assets/content/details_sections.json"
      ];

      for (String file in jsonFiles) {
        final String response = await rootBundle.loadString(file);
        final List<dynamic> jsonData = json.decode(response);
        // print( "dddllllllllllllllllllllllllllll*************999999999999)");
        // print(jsonData);
        _dataCache.addAll(jsonData.cast<Map<String, dynamic>>());
      }
      print('Data loaded successfully. Total items: ${_dataCache.length}');
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  /// Get all cached data
  static List<Map<String, dynamic>> getAllData() {
    return _dataCache;
  }

  /// Get data by group key
  static List<Map<String, dynamic>> getDataByGroup(String groupKey) {
    return _dataCache.where((item) => item['group'] == groupKey).toList();
  }

  /// Search across all data
  static List<Map<String, dynamic>> search(String keyword) {
    return _dataCache.where((item) {
      final title = item['title']?.toString().toLowerCase() ?? '';
      final description = item['description']?.toString().toLowerCase() ?? '';
      return title.contains(keyword.toLowerCase()) ||
          description.contains(keyword.toLowerCase());
    }).toList();
  }

  /// Get data by type (e.g., basic)
  static List<Map<String, dynamic>> getBasicData() {
    return _dataCache
        .where((item) => item['type'] == RoadmapItems.basic)
        .toList();
  }
}
