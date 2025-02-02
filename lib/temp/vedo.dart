import 'package:flutter/material.dart';

class MemeCreator extends StatefulWidget {
  @override
  _MemeCreatorState createState() => _MemeCreatorState();
}

class _MemeCreatorState extends State<MemeCreator> {
  String memeText = '';
  bool showAnimation = false;

  void applyAnimation() {
    setState(() {
      showAnimation = true;
    });
    // You can add your animation logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meme Creator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    memeText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter meme text',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: applyAnimation,
              child: Text('Apply Animation'),
            ),
            AnimatedOpacity(
              opacity: showAnimation ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: Text(
                memeText,
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 3.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
