import 'package:gotodone/models/code_tip_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TipDetailPage extends StatelessWidget {
  final CodeTipModel tip;

  TipDetailPage({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tip Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Day: ${tip.day}'),
            SizedBox(height: 8),
            Text('Tip: ${tip.tip}'),
            SizedBox(height: 8),
            Text('Level: ${tip.level}'),
          ],
        ),
      ),
    );
  }
}
