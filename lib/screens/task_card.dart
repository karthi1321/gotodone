import 'package:flutter/material.dart';
import 'package:gotodone/models/task_model.dart';

class TaskCard extends StatefulWidget {
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
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  // Variables for flag color and priority level
  late Color? priorityFlag = widget.task.priorityFlag;
  late int? priorityLevel = widget.task.priorityLevel;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
      child: InkWell(
        onTap: widget.onComplete,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Reduced padding
          child: Row(
            children: [
              // Left Side: Radio button (for task completion)
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: widget.task.status == 2
                    ? Icon(Icons.radio_button_checked, color: Colors.green, size: 30)
                    : Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 30),
              ),
              // Task title and label
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task Title
                    Text(
                      widget.task.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Task Label
                    Text(
                      widget.task.label,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    
                  ],
                ),
              ),
              // Right Side: Save and Flag buttons
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: widget.task.isFav
                        ? Icon(Icons.star, color: Colors.yellow)
                        : Icon(Icons.star_border),
                    onPressed: widget.onSave,
                    tooltip: widget.task.isFav
                        ? 'Remove from Favorites'
                        : 'Add to Favorites',
                  ),
                  // Flag Button (only shown if flag color isn't selected)
                  IconButton(
                    icon: Icon(Icons.flag, color: priorityFlag ?? Colors.grey),
                    onPressed: () {
                      _showFlagColorDialog(context);
                    },
                    tooltip: 'Set Flag Color',
                  )
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog to select flag color
  void _showFlagColorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Flag Color'),
          content: Wrap(
            children: [
              _buildFlagOption(Colors.red, 'High', context),
              _buildFlagOption(Colors.orange, 'Medium', context),
              _buildFlagOption(Colors.green, 'Low', context),
              _buildFlagOption(Colors.blue, 'None', context),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                widget.onSave();
                setState(() {
                  priorityFlag = widget.task.priorityFlag; // Update the flag color
                });
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

  // Helper for flag color selection
  Widget _buildFlagOption(Color color, String label, BuildContext context) {
    return IconButton(
      icon: Icon(Icons.circle, color: color),
      onPressed: () {
        setState(() {
          widget.task.priorityFlag = color; // Update the task's flag
          priorityFlag = color; // Update the state to reflect the new flag
        });
        Navigator.pop(context); // Close the dialog
      },
    );
  }

  // Dialog to select priority level
  void _showPriorityLevelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Priority Level'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select priority level (1 to 5):'),
              Slider(
                value: widget.task.priorityLevel?.toDouble() ?? 3.0,
                min: 1,
                max: 5,
                divisions: 4,
                onChanged: (value) {
                  setState(() {
                    widget.task.priorityLevel = value.toInt();
                    priorityLevel = widget.task.priorityLevel; // Update the priority level
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                widget.onSave();
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
}
