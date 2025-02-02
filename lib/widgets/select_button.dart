import 'package:flutter/material.dart';

class SelectButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Key? key;

  SelectButton({
    required this.text,
    required this.onPressed,
    this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
      child: Text(text),
    );
  }
}
