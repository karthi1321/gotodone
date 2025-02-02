import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  int id;
  int status; // 1 for incomplete, 2 for completed
  String title;
  int createdTime;
  String label;
  int modifiedTime;
  bool hasSubtask;
  bool hasAttachment;
  bool isFav;
  int? completedTime; // New field to store completion time

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
    this.completedTime,
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
        'completed_time': completedTime, // Serialize the completed time
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
      completedTime: json['completed_time'], // Deserialize completed time
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

  void _markTaskCompleted(int index) {
    setState(() {
      _tasks[index].status = 2; // Mark as completed
      _tasks[index].completedTime = DateTime.now().millisecondsSinceEpoch;
    });
    _saveTasks();
  }

  void _showAddTaskDialog() {
    TextEditingController taskController = TextEditingController();
    bool isFav = false;

    showModalBottomSheet(
      isScrollControlled: true, 
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      labelText: "Task Name",
                      labelStyle: TextStyle(color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Favorite",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return IconButton(
                            icon: Icon(
                              isFav ? Icons.star : Icons.star_border,
                              color: isFav ? Colors.yellow : Colors.grey,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                isFav = !isFav;
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _addTask(taskController.text, isFav);
                      Navigator.pop(context);
                    },
                    child: Text("Save Task", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return TaskCard(
            task: _tasks[index],
            onComplete: () => _markTaskCompleted(index),
            onRemove: () => _removeTask(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback onRemove;

  const TaskCard({
    required this.task,
    required this.onComplete,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: onComplete,
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 48.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task.label,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                          if (task.status == 2) ...[
                            const SizedBox(height: 8),
                            Text(
                              "Completed at: ${DateTime.fromMillisecondsSinceEpoch(task.completedTime!)}",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.info_outline),
                color: Colors.blue,
                onPressed: () {
                  // Handle showing task details
                },
                tooltip: 'Details',
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: IconButton(
                icon: task.isFav ? Icon(Icons.star, color: Colors.yellow) : Icon(Icons.star_border),
                onPressed: () {
                  // Handle toggling favorite status
                },
                tooltip: task.isFav ? 'Remove from Favorites' : 'Add to Favorites',
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onRemove,
                tooltip: 'Remove Task',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
