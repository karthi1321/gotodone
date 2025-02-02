import 'package:flutter/material.dart';

class FlagColorSelector extends StatelessWidget {
  final Color? currentColor;
  final VoidCallback onTap;

  const FlagColorSelector({required this.currentColor, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.flag, color: currentColor ?? Colors.grey),
      onPressed: onTap,
      tooltip: 'Set Flag Color',
    );
  }
}
