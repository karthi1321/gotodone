import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gitgo/screens/session_page.dart';
import 'package:gitgo/utils/DataCache.dart';
import 'package:gitgo/utils/command_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'commands_list_page.dart'; // Import the existing CommandCard

class SavedCommandsPage extends StatefulWidget {
  @override
  _SavedCommandsPageState createState() => _SavedCommandsPageState();
}

class _SavedCommandsPageState extends State<SavedCommandsPage> {
  List<dynamic> allCommands = []; // Full list of commands from JSON
  List<dynamic> savedCommands = []; // Filtered saved commands
  List<Map<String, dynamic>> userCreatedCommands = []; // User-added commands
  Set<String> savedTitles = {}; // Titles of saved commands
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCommands();
  }

  Future<void> _loadSavedCommands() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedTitles = prefs.getStringList('savedCommands')?.toSet() ?? {};
    String? userCommandsJson = prefs.getString('userCreatedCommands');

    if (userCommandsJson != null) {
      userCreatedCommands =
          List<Map<String, dynamic>>.from(json.decode(userCommandsJson));
    }

    await _loadCommandsData();
  }

  Future<void> _loadCommandsData() async {
    try {
      final List<dynamic> data = DataCache.getAllData();
      setState(() {
        allCommands = data;
        savedCommands =
            data.where((cmd) => savedTitles.contains(cmd['title'])).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error loading JSON: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addUserCommand(String title, String command, String syntax,
      String description, String example) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final newCommand = {
      'title': title,
      'command': command,
      'syntax': syntax,
      'description': description,
      'example': example,
      'isUserCreated': true,
    };

    setState(() {
      userCreatedCommands.add(newCommand);
    });

    prefs.setString('userCreatedCommands', json.encode(userCreatedCommands));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Command "$title" added successfully'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _removeCommand(String title) async {
    bool confirm = await _showConfirmationDialog(title);
    if (!confirm) return; // If the user cancels, return early

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedTitles.remove(title); // Remove from saved titles
      savedCommands
          .removeWhere((cmd) => cmd['title'] == title); // Remove from UI list
      userCreatedCommands.removeWhere(
          (cmd) => cmd['title'] == title); // Remove user-added commands
      prefs.setStringList(
          'savedCommands', savedTitles.toList()); // Update storage
      prefs.setString('userCreatedCommands', json.encode(userCreatedCommands));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title removed from saved commands'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<bool> _showConfirmationDialog(String title) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Confirm Remove',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  fontFamily: 'Arial',
                  color: Colors.blue,
                ),
              ),
              content: Text(
                'Are you sure you want to remove "$title"?',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Arial',
                  color: Colors.black87,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Remove',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _showAddCommandDialog() {
    String title = '';
    String command = '';
    String syntax = '';
    String description = '';
    String example = ''; // New field for example

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Add New Command',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Arial',
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '* Required fields',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.redAccent,
                  fontFamily: 'Arial',
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  label: 'Title *',
                  onChanged: (value) => title = value,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Command *',
                  onChanged: (value) => command = value,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Syntax',
                  onChanged: (value) => syntax = value,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Description *',
                  onChanged: (value) => description = value,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Example',
                  onChanged: (value) => example = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.redAccent,
                ),
              ),
            ),
           ElevatedButton(
  onPressed: () {
    if (title.isNotEmpty &&
        command.isNotEmpty &&
        description.isNotEmpty) {
      _addUserCommand(title, command, syntax, description, example);
      
      // Close the dialog first, then show the SnackBar
      Navigator.of(context).pop();
      
      // Use a post-frame callback to ensure the dialog is fully closed before showing the SnackBar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Command added successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: const Text(
    'Add',
    style: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
  ),
),

          ],
        );
      },
    );
  }

  Widget _buildTextField(
      {required String label, required Function(String) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            fontFamily: 'Arial',
            color: Colors.black87, // Original color without opacity
          ).copyWith(
            color: Colors.black87.withOpacity(0.6), // Applying low opacity
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
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
          title: const Text(
            "Saved Commands",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Saved Commands",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: savedCommands.isEmpty && userCreatedCommands.isEmpty
          ? const Center(
              child: Text(
                'No saved commands found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: savedCommands.length + userCreatedCommands.length,
               physics: BouncingScrollPhysics(), // Enables bouncing scroll
              itemBuilder: (context, index) {
                if (index < savedCommands.length) {
                  final command = savedCommands[index];
                  return CommandCard(
                    title: command['title'],
                    subtitle: command['description'],
                    icon: Icons.bookmark,
                    color: Colors.blue,
                    isSaved: true,
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
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  SessionPage(command: command['command']),
                        ),
                      );
                    },
                    onInfoPressed: () =>
                        CommandUtils.showCommandDetails(context, command),
                    onSavePressed: () => _removeCommand(command['title']),
                  );
                } else {
                  final userCommand =
                      userCreatedCommands[index - savedCommands.length];
                  return CommandCard(
                    title: userCommand['title'],
                    subtitle: userCommand['description'],
                    icon: Icons.person,
                    color: Colors.green,
                    isSaved: true,
                    onTap: () {
                      CommandUtils.showCommandDetails(context, userCommand);
                    },
                    onInfoPressed: () =>
                        CommandUtils.showCommandDetails(context, userCommand),
                    onSavePressed: () => _removeCommand(userCommand['title']),
                  );
                }
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddCommandDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
