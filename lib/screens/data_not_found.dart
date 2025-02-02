import 'package:flutter/material.dart';

class DataNotFoundMessage extends StatelessWidget {
  final VoidCallback onRetry;

  const DataNotFoundMessage({Key? key, required this.onRetry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Data not found, please try again.',
          style: TextStyle(fontSize: 16.0),
        ),
        ElevatedButton(
          onPressed: onRetry,
          child: Text('Try Again'),
        ),
      ],
    );
  }
}
