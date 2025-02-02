import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gotodone/models/task_model.dart';

class TaskManager {
  static const String _key = 'tasks';

  static Future<List<Task>> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskList = prefs.getStringList(_key);
    return taskList == null
        ? []
        : taskList.map((task) => Task.fromJson(json.decode(task))).toList();
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskList = tasks.map((task) => json.encode(task.toJson())).toList();
    prefs.setStringList(_key, taskList);
  }

  static Future<void> markTaskCompleted(List<Task> tasks, int index) async {
    tasks[index].status = 2;
    tasks[index].completedTime = DateTime.now().millisecondsSinceEpoch;
    await saveTasks(tasks);
  }

  static Future<void> removeTask(List<Task> tasks, int index) async {
    tasks.removeAt(index);
    await saveTasks(tasks);
  }

  static Future<void> addTask(List<Task> tasks, Task task) async {
    tasks.add(task);
    await saveTasks(tasks);
  }
}
