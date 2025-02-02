import 'package:flutter/material.dart';
import 'package:gotodone/models/task_model.dart';
import 'package:gotodone/screens/TaskDialog.dart';
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
    // Load tasks from SharedPreferences
    List<Task> tasks = await TaskManager.loadTasks();
    setState(() {
      _tasks = tasks; // Only update the state once after loading tasks
    });
  }

  Future<void> _saveTasks() async {
    await TaskManager.saveTasks();
  }

  void _addTask(String title, bool isFav) {
    if (title.isNotEmpty) {
      print('Attempting to add task: $title');

      // Generate a new unique task ID
      Task newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch,  // Unique ID based on timestamp
        status: 1,
        title: title,
        createdTime: DateTime.now().millisecondsSinceEpoch,
        label: "work",
        modifiedTime: DateTime.now().millisecondsSinceEpoch,
        hasSubtask: false,
        hasAttachment: false,
        isFav: isFav,
      );

      // Check for duplicate task in _tasks list
      bool taskExists = _tasks.any((t) =>  t.id == newTask.id);
      
      if (!taskExists) {
        TaskManager.addTask( newTask);  // Add to TaskManager
        setState(() {
          _tasks.add(newTask);  // Update state and UI
        });
        print('Task added: ${newTask.id}');
      } else {
        print('Duplicate task detected, not adding: ${newTask.id}');
      }
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
        return TaskDialog(
          taskController: taskController,
          isFav: isFav,
          onSave: _addTask,
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
