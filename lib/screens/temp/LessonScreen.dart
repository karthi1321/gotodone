
import 'package:flutter/material.dart';

class CodeAnimationScreen extends StatefulWidget {
  @override
  _CodeAnimationScreenState createState() => _CodeAnimationScreenState();
}


class _CodeAnimationScreenState extends State<CodeAnimationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Code Animation Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Variable Value:',
              style: TextStyle(fontSize: 24),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Text(
                  '$_counter',
                  style: TextStyle(fontSize: 48, color: Colors.blue),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}