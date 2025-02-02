import 'package:flutter/material.dart';
import 'package:gotodone/constants/app_constants.dart';

// Define a map of titles to routes
final routeMap = {
  'Introduction to Git': '/explain',
  'Setting Up Git': '/explain',
  'Resolving Merge Conflicts': '/explain',
};

class RoadmapPage extends StatelessWidget {
  final String title;
  final List<RoadmapItem> roadmapItems;

  const RoadmapPage({
    required this.title,
    required this.roadmapItems,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(title),
      //   backgroundColor: Colors.blue,
      // ),
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            title,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        physics: BouncingScrollPhysics(), // Enables bouncing scroll

        itemCount: roadmapItems.length,
        itemBuilder: (context, index) {
          final item = roadmapItems[index];
          return RoadmapCard(
            title: item.title,
            subtitle: item.subtitle,
            icon: item.icon,
            color: item.color,
            onLearnNowPressed: () {
// Get the route dynamically or default to '/sessionPage'
              final routeName = routeMap[item.title] ?? '/sessionPage';

              Navigator.pushNamed(
                context,
                routeName,
                arguments: routeName == '/sessionPage'
                    ? {'groupKey': item.group}
                    : { 'topic': item.title ,'group': item.group},
              );
            },
          );
        },
      ),
    );
  }
}

class RoadmapCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onLearnNowPressed;

  const RoadmapCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onLearnNowPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: onLearnNowPressed,
                icon: const Icon(Icons.school, size: 20),
                label: const Text(
                  'Learn Now',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  // padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  // primary: Colors.blue,
                  // onPrimary: Colors.white,

                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  elevation: 5,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  textStyle: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoadmapItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String group;
  RoadmapItem({
    required this.title,
    required this.group,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
