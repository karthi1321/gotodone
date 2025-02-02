import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gotodone/utils/DataCache.dart';
import 'package:gotodone/utils/tts_utils';
 
class SessionPage extends StatefulWidget {
  final String command;

  SessionPage({required this.command});

  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  Map<String, dynamic>? commandData;
  bool isLoading = true;
  bool isError = false;
  bool isSpeaking = false;
  bool _showStory = false; // For fade-in animation

  @override
  void initState() {
    super.initState();
    _loadCommandData();
  }

  Future<void> _loadCommandData() async {
    try {
      final List<Map<String, dynamic>> data =
          DataCache.getAllData().cast<Map<String, dynamic>>();

      final Map<String, dynamic> foundCommand = data.firstWhere(
        (item) => item['command'] == widget.command,
        orElse: () => <String, dynamic>{},
      );

      if (foundCommand.isNotEmpty) {
        setState(() {
          commandData = foundCommand;
          isLoading = false;
          _showStory = true; // Trigger fade-in animation
        });
      } else {
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading JSON: $e");
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  void _toggleTTS() {
    if (isSpeaking) {
      TtsUtils.stop();
      setState(() {
        isSpeaking = false;
      });
    } else {
      String speakText = '''
        About ${widget.command} Command.
        ${commandData!['description']}
        Example: ${commandData!['example']}
        Story Explanation: ${commandData!['story']}
      ''';
      TtsUtils.speak(speakText);
      setState(() {
        isSpeaking = true;
      });
    }
  }

  @override
  void dispose() {
    TtsUtils.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Loading..."),
          backgroundColor: Colors.blue,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (isError || commandData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Error"),
          backgroundColor: Colors.blue,
        ),
        body: const Center(
          child: Text(
            "Sorry, the command could not be found.",
            style: TextStyle(fontSize: 18, color: Colors.redAccent),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          commandData!['title'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isSpeaking ? Icons.stop : Icons.volume_up,
              color: Colors.white,
            ),
            onPressed: _toggleTTS,
            tooltip: isSpeaking ? "Stop audio" : "Listen to all content",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "About ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.command,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  commandData!['description'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Syntax:",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  commandData!['syntax'],
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Example:",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  commandData!['example'],
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 16,
                    color: Colors.blue,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Story Explanation:",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: _showStory ? 1.0 : 0.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    commandData!['story'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
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
