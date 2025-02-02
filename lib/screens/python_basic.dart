import 'package:flutter/material.dart';

class PythonBasicsRoadmapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Python Basics Roadmap'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          const RoadmapCard(
            title: 'Learn Python Syntax',
            subtitle: 'Variables, data types, basic operators, control flow',
            icon: Icons.code,
            color: Colors.orange,
          ),
          const RoadmapCard(
            title: 'Explore Python Collections',
            subtitle: 'Lists, dictionaries, sets, tuples, comprehensions',
            icon: Icons.collections,
            color: Colors.green,
          ),
          const RoadmapCard(
            title: 'Understand Functions and Modules',
            subtitle: 'Define functions, import modules, use libraries',
            icon: Icons.functions,
            color: Colors.purple,
          ),
          const RoadmapCard(
            title: 'Practice Problem Solving',
            subtitle: 'Solve coding challenges, work on projects',
            icon: Icons.lightbulb_outline,
            color: Colors.red,
          ),
          const RoadmapCard(
            title: 'Build Simple Applications',
            subtitle: 'Create basic scripts, simple games, or utility apps',
            icon: Icons.build,
            color: Colors.blue,
          ),
          const RoadmapCard(
            title: 'Join Python Community',
            subtitle: 'Participate in forums, contribute to open-source',
            icon: Icons.group,
            color: Colors.teal,
          ),
        ],
      ),
    );
  }
}

class RoadmapCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const RoadmapCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white, // Set card background color to white
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: color,
                      child: Icon(
                        icon,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                // Add navigation or action for the button
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(80, 40)),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 20),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              child: const Text(
                'Learn Now',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
