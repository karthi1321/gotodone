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
  String selectedLabel = "All";  // Default selected label

  List<String> availableLabels = ["All", "Personal", "Wishlist", "Birthday", "Work", "Shopping", "Urgent", "Family", "Important"];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    List<Task> tasks = await TaskManager.filterTasks(
      status: 3,  // You can adjust this as per your requirements
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

  // Function to change the selected label
  void _changeLabel(String label) {
    setState(() {
      selectedLabel = label;
      _loadTasks();  // Reload tasks when label is changed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To-Do List", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          // Horizontal Scrollable Labels with better styling
          Container(
            margin: EdgeInsets.only(right: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,  // Enable horizontal scrolling
              child: Row(
                children: availableLabels.map((label) {
                  return GestureDetector(
                    onTap: () => _changeLabel(label),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Chip(
                        label: Text(
                          label,
                          style: TextStyle(
                            color: selectedLabel == label ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: selectedLabel == label ? Colors.blueAccent : Colors.grey[200],
                        avatar: Icon(Icons.label, color: selectedLabel == label ? Colors.white : Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: selectedLabel == label ? 4 : 0,
                      ),
                    ),
                  );
                }).toList(),
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
