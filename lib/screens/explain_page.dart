import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class ExplainPage extends StatefulWidget {
  final String topic;
  final String group;

  ExplainPage({required this.topic, required this.group});

  @override
  _ExplainPageState createState() => _ExplainPageState();
}

class _ExplainPageState extends State<ExplainPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<Map<String, String>> _sections = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _loadSections();
  }

  Future<void> _loadSections() async {
    final String jsonString =
        await rootBundle.loadString('assets/content/details_sections.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    setState(() {
      _sections = jsonData
          .where((section) => section['group'] == widget.group)
          .map((section) => {
                'title': section['title'] as String,
                'content': section['content'] as String
              })
          .toList();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildContent(String content) {
    final List<InlineSpan> spans = [];
    final regex = RegExp(r'(\*\*.*?\*\*|```.*?```|\n)', dotAll: true);
    final matches = regex.allMatches(content);

    int lastMatchEnd = 0;

    for (var match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: content.substring(lastMatchEnd, match.start),
          style:
              const TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
        ));
      }

      final matchText = match.group(0)!;

      if (matchText.startsWith('**') && matchText.endsWith('**')) {
        // Highlight bold text
        spans.add(TextSpan(
          text: matchText.replaceAll('**', ''),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blue,
          ),
        ));
      } else if (matchText.startsWith('```') && matchText.endsWith('```')) {
        // Highlight code block
        spans.add(WidgetSpan(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey.shade200,
            child: Text(
              matchText.replaceAll('```', '').trim(),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ));
      } else if (matchText == '\n') {
        // Handle new line
        spans.add(const TextSpan(text: '\n'));
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < content.length) {
      spans.add(TextSpan(
        text: content.substring(lastMatchEnd),
        style:
            const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
      textAlign: TextAlign.start,
    );
  }

  void _nextSection() {
    if (_currentIndex < _sections.length - 1) {
      setState(() {
        _animationController.reset();
        _currentIndex++;
        _animationController.forward();
      });
    } else {
      _showEndDialog();
    }
  }

  void _previousSection() {
    if (_currentIndex > 0) {
      setState(() {
        _animationController.reset();
        _currentIndex--;
        _animationController.forward();
      });
    }
  }

  void _showEndDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("End of Topic"),
          content: const Text(
              "You have completed the topic. Would you like to go back to the home page?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Navigate back to the home page
              },
              child: const Text("Go to Home"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_sections.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.topic),
          backgroundColor: Colors.blue,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final currentSection = _sections[_currentIndex];
    final progress = (_currentIndex + 1) / _sections.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text(
          widget.topic,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade300,
                color: Colors.blue,
              ),
            ),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentSection['title']!,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 16),
                      _buildContent(currentSection['content']!),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _currentIndex > 0 ? () => _previousSection() : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _currentIndex > 0 ? Colors.blue : Colors.grey.shade300,
                ),
                child: const Text(
                  "Previous",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: _currentIndex < _sections.length - 1
                    ? () => _nextSection()
                    : () => _showEndDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _currentIndex < _sections.length - 1
                      ? Colors.blue
                      : Colors.green,
                ),
                child: Text(
                  _currentIndex < _sections.length - 1 ? "Next" : "Done",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
