import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  final String solution;
  final String hint;

  GamePage({required this.solution, required this.hint});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool showHint = false;

  void _validateCommand(String input) {
    if (input.trim() == widget.solution) {
      showHint = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 Correct! Tom found Jerry.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Incorrect command. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help Tom Find Jerry"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Help Tom find Jerry by using the correct command!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "Enter command here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: () => _validateCommand(widget.solution),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showHint = true;
                });
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: const Text("Show Hint"),
            ),
            if (showHint)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  widget.hint,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
