import 'package:flutter/material.dart';
import 'package:gotodone/models/task_model.dart';
import 'package:gotodone/screens/task_card.dart';
 import 'package:gotodone/utils/task_manager.dart'; // Import TaskManager

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
    _tasks = await TaskManager.loadTasks();
    setState(() {});
  }

  Future<void> _saveTasks() async {
    await TaskManager.saveTasks(_tasks);
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
      TaskManager.addTask(_tasks, newTask);
      setState(() {
        _tasks.add(newTask);
      });
    }
  }

  void _removeTask(int index) {
    TaskManager.removeTask(_tasks, index);
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _markTaskCompleted(int index) {
    TaskManager.markTaskCompleted(_tasks, index);
    setState(() {
      _tasks[index].status = 2; // Mark as completed
      _tasks[index].completedTime = DateTime.now().millisecondsSinceEpoch;
    });
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
            onSave: () {}, // Implement save logic if needed
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
