import 'package:flutter/material.dart';
import 'package:gotodone/models/task_model.dart';
 
import 'package:gotodone/screens/task_card.dart';
import 'package:gotodone/utils/task_manager.dart';

class TaskSearchDelegate extends SearchDelegate {
  final List<Task> tasks;

  TaskSearchDelegate(this.tasks);

  // Create filter options (status and other parameters)
  String? selectedStatus = 'All'; // Default option for status filter
  List<String> statusOptions = ['All', 'Open', 'Completed'];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close the search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Filter tasks based on the search query and selected status
    final results = tasks.where((task) {
      final title = task.title.toLowerCase();
      final label = task.label.toLowerCase();
      final description = task.note ?.toLowerCase() ?? '';
      final status = task.status.toString();
      bool matchesQuery = title.contains(query.toLowerCase()) ||
          label.contains(query.toLowerCase()) ||
          description.contains(query.toLowerCase());

      bool matchesStatus = selectedStatus == 'All' || 
                           (selectedStatus == 'Open' && status == '1') || 
                           (selectedStatus == 'Completed' && status == '2');

      return matchesQuery && matchesStatus;
    }).toList();

    if (results.isEmpty) {
      return const Center(
        child: Text(
          "No tasks found.",
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final task = results[index];
        return TaskCard(
          task: task,
          onComplete: () {},
          onSave: () {},
          onRemove: () {},
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show suggestions while typing the query
    final suggestions = tasks.where((task) {
      final title = task.title.toLowerCase();
      return title.startsWith(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final task = suggestions[index];
        return ListTile(
          title: Text(task.title),
          onTap: () {
            query = task.title;
            showResults(context);
          },
        );
      },
    );
  }

  // Display the filter options for status selection
  void showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Tasks'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select Status:'),
              DropdownButton<String>(
                value: selectedStatus,
                items: statusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (newValue) {
                  selectedStatus = newValue;
                  Navigator.pop(context);  // Close the filter dialog
                  showResults(context);  // Reapply the filter
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
class TaskSearchPage extends StatefulWidget {
  @override
  _TaskSearchPageState createState() => _TaskSearchPageState();
}

class _TaskSearchPageState extends State<TaskSearchPage> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks using TaskManager without passing arguments
  Future<void> _loadTasks() async {
    tasks = await TaskManager.loadTasks();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TaskSearchDelegate(tasks), // Use the loaded tasks here
              );
            },
          ),
        ],
      ),
      body: tasks.isEmpty
          ? const Center(child: CircularProgressIndicator())  // Loading indicator while tasks are fetched
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskCard(
                  task: task,
                  onComplete: () {},
                  onSave: () {},
                  onRemove: () {},
                );
              },
            ),
    );
  }
}
