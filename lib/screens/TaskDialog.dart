import 'package:flutter/material.dart';

class TaskDialog extends StatelessWidget {
  final TextEditingController taskController;
  late final bool isFav;
  final Function(String, bool) onSave;

  TaskDialog({
    required this.taskController,
    required this.isFav,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Task Name Input
              TextField(
                controller: taskController,
                decoration: InputDecoration(
                  labelText: "Task Name",
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 20),

              // Favorite Toggle with Save Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Favorite",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  Row(
                    children: [
                      StatefulBuilder(
                        builder: (context, setState) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                isFav = !isFav;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isFav ? Colors.yellow[700] : Colors.transparent,
                                border: Border.all(
                                  color: isFav ? Colors.yellow[700]! : Colors.grey,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),  // Reduced padding for smaller circle
                                child: Icon(
                                  isFav ? Icons.star : Icons.star_border,
                                  color: isFav ? Colors.white : Colors.grey,
                                  size: 22, // Smaller star size
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          onSave(taskController.text, isFav);
                          Navigator.pop(context);
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
