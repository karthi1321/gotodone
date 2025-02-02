import 'package:flutter/material.dart';

class TaskCompletionRadio extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback onTap;

  const TaskCompletionRadio({required this.isCompleted, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isCompleted ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isCompleted ? Colors.green : Colors.grey,
        size: 30,
      ),
    );
  }
}
