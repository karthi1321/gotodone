import 'package:flutter/material.dart';
import 'package:gotodone/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onComplete;
  final VoidCallback onSave;
  final VoidCallback onRemove;

  const TaskCard({
    required this.task,
    required this.onComplete,
    required this.onSave,
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
      child: InkWell(
        onTap: onComplete,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Left Side: Priority icon (High / Low)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  task.status == 2 ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: task.status == 2 ? Colors.green : Colors.grey,
                  size: 30,
                ),
              ),
              // Task title and label
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task Title
                    Text(
                      task.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Task Label
                    Text(
                      task.label,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    // Task Priority (Flag and Level)
                    if (task.priorityFlag != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.flag,
                            color: task.priorityFlag,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text('Priority: ${task.priorityLevel}'),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Right Side: Save and Flag button
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: task.isFav
                        ? Icon(Icons.star, color: Colors.yellow)
                        : Icon(Icons.star_border),
                    onPressed: onSave,
                    tooltip: task.isFav
                        ? 'Remove from Favorites'
                        : 'Add to Favorites',
                  ),
                  IconButton(
                    icon: Icon(Icons.flag, color: task.priorityFlag ?? Colors.grey),
                    onPressed: () {
                      _showPriorityDialog(context);
                    },
                    tooltip: 'Set Priority',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPriorityDialog(BuildContext context) {
    // Show a dialog for selecting the priority flag and level
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Task Priority'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Flag color options
              Wrap(
                children: [
                  _buildFlagOption(Colors.red, 'High', context),
                  _buildFlagOption(Colors.orange, 'Medium', context),
                  _buildFlagOption(Colors.yellow, 'Low', context),
                  _buildFlagOption(Colors.green, 'Completed', context),
                  _buildFlagOption(Colors.blue, 'None', context),
                ],
              ),
              // Priority level (1 to 5)
              const SizedBox(height: 16),
              Text('Priority Level (1 to 5):'),
              Slider(
                value: task.priorityLevel?.toDouble() ?? 3.0,
                min: 1,
                max: 5,
                divisions: 4,
                onChanged: (value) {
                  // Update the priority level
                  task.priorityLevel = value.toInt();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Save the priority flag and level
                onSave();
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFlagOption(Color color, String label, BuildContext context) {
    return IconButton(
      icon: Icon(Icons.circle, color: color),
      onPressed: () {
        // Update task's flag color
        task.priorityFlag = color;
        Navigator.pop(context); // Close the dialog
        onSave(); // Update the task
      },
    );
  }
}
