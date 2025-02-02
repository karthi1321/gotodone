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
              TextField(
                controller: taskController,
                decoration: InputDecoration(
                  labelText: "Task Name",
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Favorite",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.star : Icons.star_border,
                          color: isFav ? Colors.yellow : Colors.grey,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            isFav = !isFav;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  onSave(taskController.text, isFav);
                  Navigator.pop(context);
                },
                child: Text("Save Task", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
