import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gotodone/models/task_model.dart';

class TaskManager {
  static const String _key = 'tasks';

  // Global cache for tasks to avoid duplicate additions
  static final List<Task> _taskCache = [];

  // Load tasks from SharedPreferences
  static Future<List<Task>> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList(_key);
    if (taskList != null) {
      // If tasks are available in SharedPreferences, load them into the cache
      _taskCache.clear();  // Clear existing cache
      _taskCache.addAll(taskList.map((task) => Task.fromJson(json.decode(task))).toList());
    }
    return List.from(_taskCache); // Return a copy of the cache
  }

  // Save tasks to SharedPreferences
  static Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = _taskCache.map((task) => json.encode(task.toJson())).toList();
    await prefs.setStringList(_key, taskList);
  }

  // Mark a task as completed
  static Future<void> markTaskCompleted(List<Task> tasks, int index) async {
    tasks[index].status = 2;
    tasks[index].completedTime = DateTime.now().millisecondsSinceEpoch;
    await saveTasks();
  }

  // Remove a task
  static Future<void> removeTask(List<Task> tasks, int index) async {
    tasks.removeAt(index);
    await saveTasks();
  }

  // Add a task to the cache (and avoid duplicates)
  static Future<void> addTask(Task task) async {
    // Check if the task is already in the cache by its ID or title
    bool taskExists = _taskCache.any((t) => t.id == task.id || t.title == task.title);
    
    if (!taskExists) {
      // Add the task to the cache and save it to SharedPreferences
      _taskCache.add(task);
      await saveTasks();
      print("Task added: ${task.title}");
    } else {
      print("Duplicate task detected, not adding: ${task.title}");
    }
  }
}
