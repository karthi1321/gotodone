import 'package:flutter/material.dart';
import 'package:gitgo/screens/session_page.dart';
import 'package:gitgo/utils/DataCache.dart';
import 'package:gitgo/utils/command_save_utils.dart';
import 'package:gitgo/utils/command_utils.dart';
import 'commands_list_page.dart'; // Import CommandCard

class CommandsSearchPage extends StatefulWidget {
  @override
  _CommandsSearchPageState createState() => _CommandsSearchPageState();
}

class _CommandsSearchPageState extends State<CommandsSearchPage> {
  List<dynamic> _commands = [];
  List<dynamic> _filteredCommands = [];
  bool _isLoading = true;
  String _searchQuery = "";
  Set<String> savedCommands = {}; // To track saved commands

  @override
  void initState() {
    super.initState();
    _loadSavedCommands();
    _loadCommandsData();
  }

  Future<void> _loadSavedCommands() async {
    savedCommands = await CommandSaveUtils.loadSavedCommands();
    setState(() {});
  }

  Future<void> _toggleSaveCommand(String title) async {
    await CommandSaveUtils.toggleSaveCommand(
        title: title, savedCommands: savedCommands);
    setState(() {});
  }

  Future<void> _loadCommandsData() async {
    try {
      final List<dynamic> data = DataCache.getAllData();
      setState(() {
        _commands = data;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading JSON: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterCommands(String query) {
    setState(() {
      _searchQuery = query;
      _filteredCommands = _commands.where((command) {
        final title = command['title'].toString().toLowerCase();
        final cmd = command['command'].toString().toLowerCase();
        final searchQuery = query.toLowerCase();

        return title.contains(searchQuery) || cmd.contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 2,
        title: TextField(
          autofocus: true,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Arial',
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: 'Search by title or command...',
            hintStyle: const TextStyle(
              fontSize: 14,
              fontFamily: 'Arial',
              color: Colors.white70,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none, // Completely removes the border
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none, // No border on focus
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none, // No border when enabled
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: 10), // Removes underline when enabled
          ),
          cursorColor: Colors.white,
          onChanged: _filterCommands,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredCommands.isEmpty
              ? Center(
                  child: Text(
                    _searchQuery.isEmpty
                        ? 'Start searching by typing in the search bar.'
                        : 'No results found for "$_searchQuery".',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Arial',
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredCommands.length,
                  itemBuilder: (context, index) {
                    final command = _filteredCommands[index];
                    return CommandCard(
                      title: command['title'],
                      subtitle: command['description'],
                      icon: Icons.search,
                      color: Colors.blue,
                      isSaved: savedCommands.contains(command['title']),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                      onInfoPressed: () {
                        CommandUtils.showCommandDetails(context, command);
                      },
                      onSavePressed: () {
                        _toggleSaveCommand(command['title']);
                      },
                    );
                  },
                ),
    );
  }
}
