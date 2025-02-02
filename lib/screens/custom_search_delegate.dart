import 'package:flutter/material.dart';
import 'package:gotodone/screens/session_page.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<dynamic> commands;

  CustomSearchDelegate(this.commands);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close the search
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = commands.where((command) {
      final title = command['title'].toString().toLowerCase();
      final description = command['description'].toString().toLowerCase();
      return title.contains(query.toLowerCase()) ||
          description.contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return const Center(
        child: Text(
          "No commands found.",
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final command = results[index];
        return ListTile(
          title: Text(command['title']),
          subtitle: Text(command['description']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SessionPage(command: command['command']),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = commands.where((command) {
      final title = command['title'].toString().toLowerCase();
      return title.startsWith(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final command = suggestions[index];
        return ListTile(
          title: Text(command['title']),
          onTap: () {
            query = command['title'];
            showResults(context);
          },
        );
      },
    );
  }
}
