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
    return widget.task.status == 1 ? Card( // Only show tasks with status 1
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: widget.onComplete,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: widget.task.status == 2
                    ? Icon(Icons.radio_button_checked, color: Colors.green, size: 30)
                    : Icon(Icons.radio_button_unchecked, color: Colors.grey, size: 30),
              ),
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
                        ? Icon(Icons.star, color: Colors.yellow)
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
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ) : SizedBox.shrink();
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
                _saveFlagAndFavoriteStatus();
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
