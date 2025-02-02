
import 'package:flutter/material.dart';

class CommandExplorer extends StatefulWidget {
  @override
  _CommandExplorerState createState() => _CommandExplorerState();
}

class _CommandExplorerState extends State<CommandExplorer> {
  final TextEditingController _commandController = TextEditingController();
  List<String> _output = [];

  // Simulate output based on command input
  void _executeCommand(String command) {
    // Sample command-output simulation
    String output;
    switch (command.trim().toLowerCase()) {
      case 'ls':
        output = 'file1.txt\nfile2.txt\nfolder1/';
        break;
      case 'pwd':
        output = '/home/user';
        break;
      case 'cat file1.txt':
        output = 'This is file1 content.';
        break;
      default:
        output = 'bash: $command: command not found';
    }

    setState(() {
      _output.add('\$ $command');
      _output.add(output);
    });

    _commandController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Command Explorer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Command Input Field
            TextField(
              controller: _commandController,
              decoration: InputDecoration(
                labelText: 'Enter Command',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_commandController.text.isNotEmpty) {
                      _executeCommand(_commandController.text);
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            // Terminal Output Area
            Expanded(
              child: ListView.builder(
                itemCount: _output.length,
                itemBuilder: (context, index) {
                  return Text(
                    _output[index],
                    style: TextStyle(fontFamily: 'monospace', fontSize: 16),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}