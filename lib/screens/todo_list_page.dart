import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gotodone/models/task_model.dart';
import 'package:gotodone/screens/TaskDialog.dart';
import 'package:gotodone/screens/task_card.dart';
import 'package:gotodone/utils/task_manager.dart'; // Import TaskManager
import 'package:shared_preferences/shared_preferences.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Task> _tasks = [];
  String selectedLabel = "All";  // Default selected label
  bool showCompletedTasks = false;  // Flag to toggle between open and completed tasks

  @override
  void initState() {
    super.initState();
    _loadSelectedLabel();  // Load saved label when the page is initialized
    _loadTasks();
  }

  // Load the selected label from SharedPreferences
  Future<void> _loadSelectedLabel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedLabel = prefs.getString('selectedLabel') ?? "All";  // Default to "All" if no label is saved
    setState(() {
      selectedLabel = savedLabel;  // Update the selected label
    });
  }

  // Save the selected label to SharedPreferences
  Future<void> _saveSelectedLabel(String label) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLabel', label);  // Save the label to SharedPreferences
  }

  // Load tasks based on the selected label and task completion status
  Future<void> _loadTasks() async {
    List<Task> tasks = await TaskManager.filterTasks(
      status: showCompletedTasks ? 2 : 1,  // 1 for open tasks, 2 for completed tasks
      label: selectedLabel == "All" ? null : selectedLabel,  // Filter tasks based on selected label
    );
    // Sort tasks by created time for open tasks and completed time for completed tasks
    tasks.sort((a, b) {
      DateTime aTime = showCompletedTasks ? DateTime.fromMillisecondsSinceEpoch(a.completedTime ?? 0) : DateTime.fromMillisecondsSinceEpoch(a.createdTime);
      DateTime bTime = showCompletedTasks ? DateTime.fromMillisecondsSinceEpoch(b.completedTime??0) : DateTime.fromMillisecondsSinceEpoch(b.createdTime);
      return bTime.compareTo(aTime); // Sort in descending order
    });
    setState(() {
      _tasks = tasks; // Update state after loading tasks
    });
  }

  // Toggle between showing open and completed tasks
  void _toggleShowCompletedTasks() {
    setState(() {
      showCompletedTasks = !showCompletedTasks;
      _loadTasks(); // Reload tasks based on new filter
    });
  }

  // Add a new task
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
          _tasks.insert(0, newTask);  // Add new task at the top
        });
      }
    }
  }

  // Remove a task
  void _removeTask(int index) {
    TaskManager.removeTask(_tasks, index);
    setState(() {
      _tasks.removeAt(index);
    });
  }

  // Mark a task as completed
  void _markTaskCompleted(int index) {
    TaskManager.markTaskCompleted(_tasks, index);
    setState(() {
      _tasks[index].status = 2;
      _tasks[index].completedTime = DateTime.now().millisecondsSinceEpoch;
    });
  }

  // Show the add task dialog
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

  // Show the label selection dialog
  void _showLabelSelectionDialog() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          height: 300,
          child: ListView(
            children: [
              ListTile(
                title: Text("All", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                onTap: () {
                  setState(() {
                    selectedLabel = "All";
                    _loadTasks(); // Reload tasks with no label filter
                  });
                  _saveSelectedLabel("All"); // Save the selected label
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Personal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                onTap: () {
                  setState(() {
                    selectedLabel = "Personal";
                    _loadTasks(); // Reload tasks with "Personal" label filter
                  });
                  _saveSelectedLabel("Personal"); // Save the selected label
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Wishlist", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                onTap: () {
                  setState(() {
                    selectedLabel = "Wishlist";
                    _loadTasks(); // Reload tasks with "Wishlist" label filter
                  });
                  _saveSelectedLabel("Wishlist"); // Save the selected label
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Birthday", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                onTap: () {
                  setState(() {
                    selectedLabel = "Birthday";
                    _loadTasks(); // Reload tasks with "Birthday" label filter
                  });
                  _saveSelectedLabel("Birthday"); // Save the selected label
                  Navigator.pop(context);
                },
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
        title: Text(
          selectedLabel == "All" ? "Tasks" : "$selectedLabel Tasks",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,  // Using the theme's primary color
        elevation: 5,
        actions: [
          GestureDetector(
            onTap: _showLabelSelectionDialog,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Chip(
                label: Text(
                  selectedLabel,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Theme.of(context).primaryColor,  // Using the theme's primary color
                avatar: Icon(Icons.label, color: Colors.white),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _toggleShowCompletedTasks,
            tooltip: 'Show Completed Tasks',
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
               itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Container(
                  child: TaskCard(
                    task: _tasks[index],
                    onComplete: () => _markTaskCompleted(index),
                    onRemove: () => _removeTask(index),
                    onSave: () {}, // Implement save logic if needed
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add, size: 30),
        backgroundColor: Theme.of(context).primaryColor,  // Using the theme's primary color
        elevation: 10,
      ),
    );
  }
}
