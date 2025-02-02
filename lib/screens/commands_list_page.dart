import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gitgo/constants/app_constants.dart';
import 'package:gitgo/screens/commands_search_page.dart';
import 'package:gitgo/utils/DataCache.dart';
import 'package:gitgo/utils/command_save_utils.dart';
import 'package:gitgo/utils/command_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gitgo/screens/session_page.dart';

class CommandsListPage extends StatefulWidget {
  final String groupKey; // New argument to specify the group

  const CommandsListPage({Key? key, required this.groupKey}) : super(key: key);

  @override
  _CommandsListPageState createState() => _CommandsListPageState();
}

class _CommandsListPageState extends State<CommandsListPage> {

   Future<void> _toggleSaveCommand(String title) async {
    await CommandSaveUtils.toggleSaveCommand(
        title: title, savedCommands: savedCommands);
    setState(() {});
  }
  List<dynamic> commands = [];
  Set<String> savedCommands = {}; // To track saved commands
  bool isLoading = true;
  bool isError = false;

final List<IconData> evenIcons = [
  Icons.fork_right,        // Represents branching
  Icons.merge_type,        // Represents merging branches
  Icons.settings_suggest,  // Represents configuration and setup
];
 final List<IconData> oddIcons = [
  Icons.code,              // Represents coding or version control
  Icons.terminal,          // Represents using Git in the terminal
  Icons.bug_report,        // Represents debugging or resolving conflicts
];


  @override
  void initState() {
    super.initState();
    _loadSavedCommands();
    _loadCommandsData();
  }

  Future<void> _loadSavedCommands() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedCommands = prefs.getStringList('savedCommands')?.toSet() ?? {};
    });
  }

  Future<void> _saveCommand(String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (savedCommands.contains(title)) {
        savedCommands.remove(title); // Remove if already saved
      } else {
        savedCommands.add(title); // Add if not saved
      }
      prefs.setStringList('savedCommands', savedCommands.toList());
    });
  }

  Future<void> _loadCommandsData() async {
    try {
      
        List<dynamic> data ;
      setState(() {
        if (widget.groupKey.trim().toLowerCase() == RoadmapItems.all) {
        // No filtering needed if groupKey is 'all'
        data=DataCache.getAllData(); 
        commands =  data; 
      } else if(widget.groupKey.trim().toLowerCase() == RoadmapItems.basic){

          data= DataCache.getBasicData();
        commands = data;
      }
      else {
        data=DataCache.getAllData();
        // Filter based on groupKey
        commands = data
            .where((command) =>
                command.containsKey('group') &&
                command['group'] != null &&
                command['group'].toString().trim().toLowerCase() ==
                    widget.groupKey.trim().toLowerCase())
            .toList();
      }
        isLoading = false;
      });
    } catch (e) {
      print("Error loading JSON: $e");
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

   

  Widget _buildSectionWithCopy(BuildContext context,
      {required String label,
      required String content,
      required Color iconColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            IconButton(
              icon: Icon(Icons.copy, color: iconColor, size: 20),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: content));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$label copied to clipboard"),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Courier',
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Commands List",
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (isError) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Commands List",
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: const Center(
          child: Text(
            "Error loading commands. Please try again later.",
            style: TextStyle(fontSize: 18, color: Colors.redAccent),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title:Text(
        widget.groupKey.trim().toLowerCase() == RoadmapItems.all
            ? "Git Commands"
      : "${widget.groupKey.trim().replaceAll(RegExp(r'[_-]'), ' ').split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '').join(' ')} Commands",
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
        backgroundColor: Colors.blue,
          actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CommandsSearchPage()), // Navigate to search
              );
            },
          ),
        ],
      ),
      body:  ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: commands.length,
          physics: BouncingScrollPhysics(), // Enables bouncing scroll

        itemBuilder: (context, index) {
          final command = commands[index];
          final icon = index % 2 == 0
              ? evenIcons[index % evenIcons.length]
              : oddIcons[index % oddIcons.length];
          final color = index % 2 == 0 ? Colors.blue : Colors.deepOrangeAccent ; // Orange

          return CommandCard(
            title: command['title'],
            subtitle: command['description'],
            icon: icon,
            color: color,
            isSaved: savedCommands.contains(command['title']),
            onInfoPressed: () =>
                CommandUtils.showCommandDetails(context, command),
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      SessionPage(command: command['command']),
                ),
              );
            },
            onSavePressed: () => _toggleSaveCommand(command['title']),
          );
        },
      ),
    );
  }
}

class CommandCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onInfoPressed;
  final VoidCallback onSavePressed;

  const CommandCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isSaved,
    required this.onTap,
    required this.onInfoPressed,
    required this.onSavePressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: color,
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 48.0), // Add padding to prevent overlap
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
                          const SizedBox(height: 4),
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
                  ),
                ],
              ),
            ),
            // Info icon positioned at the top-right corner
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.info_outline),
                color: Colors.blue,
                onPressed: onInfoPressed,
                tooltip: 'Details',
              ),
            ),
            // Bookmark icon positioned at the bottom-right corner
            Positioned(
              bottom: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: isSaved
                      ? const Color.fromARGB(171, 255, 153, 0)
                      : Colors.grey,
                  size: 24,
                ),
                onPressed: onSavePressed,
                tooltip: isSaved ? 'Remove from Saved' : 'Save',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
