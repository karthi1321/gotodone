import 'package:flutter/material.dart';
import 'package:gotodone/models/task_model.dart';
import 'package:gotodone/screens/TaskDialog.dart';
import 'package:gotodone/screens/task_card.dart';
import 'package:gotodone/utils/task_manager.dart'; // Import TaskManager
import 'package:flutter_svg/flutter_svg.dart';  // Import flutter_svg for SVG support

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Task> _tasks = [];
  String selectedLabel = "All";

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    List<Task> tasks = await TaskManager.filterTasks(
      status: 3, // You can adjust this as per your requirements
      label: selectedLabel == "All" ? null : selectedLabel,  // Filter tasks based on selected label
    );
    setState(() {
      _tasks = tasks; // Update state after loading tasks
    });
  }

  Future<void> _saveTasks() async {
    await TaskManager.saveTasks();
  }

  void _addTask(String title, bool isFav) {
    if (title.isNotEmpty) {
      Task newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch, 
        status: 1,
        title: title,
        createdTime: DateTime.now().millisecondsSinceEpoch,
        label: selectedLabel, // Use selected label here
        modifiedTime: DateTime.now().millisecondsSinceEpoch,
        hasSubtask: false,
        hasAttachment: false,
        isFav: isFav,
      );

      bool taskExists = _tasks.any((t) => t.id == newTask.id);
      
      if (!taskExists) {
        TaskManager.addTask(newTask);  
        setState(() {
          _tasks.add(newTask);  
        });
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
      _tasks[index].status = 2;
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

  void _showLabelSelectionDialog() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          child: ListView(
            children: [
              ListTile(
                title: Text("All"),
                onTap: () {
                  setState(() {
                    selectedLabel = "All";
                    _loadTasks(); // Reload tasks with no label filter
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Personal"),
                onTap: () {
                  setState(() {
                    selectedLabel = "Personal";
                    _loadTasks(); // Reload tasks with "Personal" label filter
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Wishlist"),
                onTap: () {
                  setState(() {
                    selectedLabel = "Wishlist";
                    _loadTasks(); // Reload tasks with "Wishlist" label filter
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Birthday"),
                onTap: () {
                  setState(() {
                    selectedLabel = "Birthday";
                    _loadTasks(); // Reload tasks with "Birthday" label filter
                  });
                  Navigator.pop(context);
                },
              ),
              // Add more labels here as needed
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
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: _showLabelSelectionDialog,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chip(
                label: Text(selectedLabel),
                backgroundColor: Colors.blueAccent,
                avatar: Icon(Icons.label, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/Checklist.svg', height: 100, width: 100),
                  const SizedBox(height: 16),
                  Text('No task in this category', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
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
