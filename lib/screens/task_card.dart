import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gotodone/models/task_model.dart';
import 'package:gotodone/screens/FavoriteTaskButton.dart';
import 'package:gotodone/screens/FlagColorSelector.dart';
import 'package:gotodone/screens/TaskCompletionRadio.dart';
import 'package:gotodone/screens/TaskInfo.dart';
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
  bool _isRemoved = false;
  bool showImage = false;  // Added flag to control image visibility

  @override
  void initState() {
    super.initState();
    _loadFlagAndFavoriteStatus();
  }

  Future<void> _loadFlagAndFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String taskId = widget.task.id.toString();

    setState(() {
      priorityFlag = Color(prefs.getInt('flag_$taskId') ?? Colors.grey.value);
      widget.task.isFav = prefs.getBool('fav_$taskId') ?? false;
      showImage = widget.task.status != 1;  // Set the flag based on task status
    });
  }

  Future<void> _saveFlagAndFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String taskId = widget.task.id.toString();

    await prefs.setInt('flag_$taskId', priorityFlag?.value ?? Colors.grey.value);
    await prefs.setBool('fav_$taskId', widget.task.isFav);
  }

  @override
  Widget build(BuildContext context) {
    return widget.task.status == 1 && !_isRemoved
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),  // Reduce vertical margin
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 6,  // Reduced blur radius for smaller shadow
                  offset: Offset(0, 2),  // Adjusted shadow position
                ),
              ],
            ),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 12.0),  // Reduced padding
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,  // Keep content centered
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),  // Reduce space around radio button
                      child: TaskCompletionRadio(
                        isCompleted: widget.task.status == 2,
                        onTap: () {
                          setState(() {
                            widget.task.status = 2;  // Mark as completed
                            _isRemoved = true;
                            showImage = true;  // Set the flag to true when completed
                          });
                          widget.onComplete();
                          _showUndoSnackBar();
                        },
                      ),
                    ),
                    Expanded(
                      child: TaskInfo(
                        title: widget.task.title,
                        label: widget.task.label,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),  // Reduce padding between buttons
                          child: FavoriteTaskButton(
                            isFav: widget.task.isFav,
                            onTap: () {
                              setState(() {
                                widget.task.isFav = !widget.task.isFav;
                              });
                              _saveFlagAndFavoriteStatus();
                              widget.onSave();
                            },
                          ),
                        ),
                        FlagColorSelector(
                          currentColor: priorityFlag,
                          onTap: () {
                            _showFlagColorDialog(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : _buildNoDataFoundMessage();
  }

  Widget _buildNoDataFoundMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showImage)  // Only show the image if showImage is true
            SvgPicture.asset(
              'assets/Checklist.svg', // Replace with your SVG path
              height: 100.0,
              width: 100.0,
            ),
          SizedBox(height: 16),
          Text(
            'No Data Found for this Category',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showUndoSnackBar() {
    final snackBar = SnackBar(
      content: Text('Task completed!'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            _isRemoved = false;
            widget.task.status = 1;
            showImage = false;  // Set the flag to false when undone
          });
          widget.onRemove();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
