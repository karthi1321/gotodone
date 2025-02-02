import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Task {
  int id;
  int status;
  String title;
  int createdTime;
  String label;
  int modifiedTime;
  bool hasSubtask;
  bool hasAttachment;
  bool isFav;

  Task({
    required this.id,
    required this.status,
    required this.title,
    required this.createdTime,
    required this.label,
    required this.modifiedTime,
    required this.hasSubtask,
    required this.hasAttachment,
    required this.isFav,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'title': title,
        'created_time': createdTime,
        'label': label,
        'modified_time': modifiedTime,
        'has_subtask': hasSubtask,
        'has_attachment': hasAttachment,
        'is_fav': isFav,
      };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      status: json['status'],
      title: json['title'],
      createdTime: json['created_time'],
      label: json['label'],
      modifiedTime: json['modified_time'],
      hasSubtask: json['has_subtask'],
      hasAttachment: json['has_attachment'],
      isFav: json['is_fav'],
    );
  }
}

class TaskStorage {
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
}

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _tasks = await TaskStorage.loadTasks();
    setState(() {});
  }

  Future<void> _saveTasks() async {
    await TaskStorage.saveTasks(_tasks);
  }

  void _addTask(String title, bool isFav) {
    if (title.isNotEmpty) {
      Task newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch,
        status: 1,
        title: title,
        createdTime: DateTime.now().millisecondsSinceEpoch,
        label: "work",
        modifiedTime: DateTime.now().millisecondsSinceEpoch,
        hasSubtask: false,
        hasAttachment: false,
        isFav: isFav,
      );
      setState(() {
        _tasks.add(newTask);
      });
      _saveTasks();
    }
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }

  void _showAddTaskDialog() {
    TextEditingController taskController = TextEditingController();
    bool isFav = false;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                decoration: InputDecoration(
                  labelText: "Task Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Favorite"),
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.star : Icons.star_border,
                      color: isFav ? Colors.yellow : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isFav = !isFav;
                      });
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _addTask(taskController.text, isFav);
                  Navigator.pop(context);
                },
                child: Text("Save"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do List"),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_tasks[index].title),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeTask(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
