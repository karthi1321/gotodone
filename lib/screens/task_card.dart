import 'package:flutter/material.dart';
import 'package:gotodone/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late Color? priorityFlag = widget.task.priorityFlag;
  late int? priorityLevel = widget.task.priorityLevel;
  bool _isRemoved = false; // To track if task was removed

  @override
  void initState() {
    super.initState();
    _loadFlagAndFavoriteStatus();
  }

  // Load the flag color and favorite status from SharedPreferences
  Future<void> _loadFlagAndFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String taskId = widget.task.id.toString();

    setState(() {
      priorityFlag = Color(prefs.getInt('flag_$taskId') ?? Colors.grey.value);
      widget.task.isFav = prefs.getBool('fav_$taskId') ?? false;
    });
  }

  // Save flag color and favorite status to SharedPreferences
  Future<void> _saveFlagAndFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String taskId = widget.task.id.toString();

    await prefs.setInt('flag_$taskId', priorityFlag?.value ?? Colors.grey.value);
    await prefs.setBool('fav_$taskId', widget.task.isFav);
  }

  @override
  Widget build(BuildContext context) {
    return widget.task.status == 1 && !_isRemoved // Only show tasks with status 1 and not removed
        ? Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell(
              onTap: () {}, // No action when tapping the card itself
              borderRadius: BorderRadius.circular(12.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Radio button to mark as completed
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.task.status = 2; // Mark task as completed
                            _isRemoved = true; // Mark as removed for visibility
                          });
                          widget.onComplete();
                          _showUndoSnackBar(); // Show undo option
                        },
                        child: widget.task.status == 2
                            ? Icon(Icons.radio_button_checked, color: Colors.green, size: 30)
                            : Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 30),
                      ),
                    ),
                    // Task details and buttons for flag and favorite
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.task.title,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
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
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: widget.task.isFav
                              ? Icon(Icons.star, color: const Color.fromARGB(255, 187, 7, 7))
                              : Icon(Icons.star_border),
                          onPressed: () {
                            setState(() {
                              widget.task.isFav = !widget.task.isFav;
                            });
                            _saveFlagAndFavoriteStatus();
                            widget.onSave();
                          },
                          tooltip: widget.task.isFav
                              ? 'Remove from Favorites'
                              : 'Add to Favorites',
                        ),
                        IconButton(
                          icon: Icon(Icons.flag, color: priorityFlag ?? Colors.grey),
                          onPressed: () {
                            _showFlagColorDialog(context);
                          },
                          tooltip: 'Set Flag Color',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : SizedBox.shrink(); // Hide task if it is marked as completed or removed
  }

  // Show a Snackbar with undo option
  void _showUndoSnackBar() {
    final snackBar = SnackBar(
      content: Text('Task completed!'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            _isRemoved = false; // Undo removal and task status
            widget.task.status = 1; // Change status back to not completed
          });
          widget.onRemove(); // Undo removal action
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        setState(() {
          widget.task.priorityFlag = color;
          priorityFlag = color;
        });
        Navigator.pop(context);
        _saveFlagAndFavoriteStatus();
      },
    );
  }
}
