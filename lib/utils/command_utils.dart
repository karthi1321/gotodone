import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommandUtils {
  static void showCommandDetails(
      BuildContext context, Map<String, dynamic> command) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "${command['command']} ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              fontSize: 20,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionWithCopy(
                  context,
                  label: "Syntax",
                  content: command['syntax'] ??
                      'No syntax provided', // Default value
                  iconColor: Colors.blueAccent,
                ),
                const SizedBox(height: 8),
                _buildSectionWithCopy(
                  context,
                  label: "Description",
                  content: command['description'] ??
                      'No description available', // Default value
                  iconColor: Colors.green,
                ),
                const SizedBox(height: 8),
                if (command['example'] !=
                    null) // Null check before building the section
                  _buildSectionWithCopy(
                    context,
                    label: "Example",
                    content: command['example'],
                    iconColor: Colors.orange,
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close",
                  style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }


//   Text(
//   label,
//   style: const TextStyle(
//     fontWeight: FontWeight.w600,
//     fontSize: 14,
//     fontFamily: 'Arial',
//     color: Colors.black87, // Original color without opacity
//   ).copyWith(
//     color: Colors.black87.withOpacity(0.6), // Applying low opacity
//   ),
// ),


  static Widget _buildSectionWithCopy(BuildContext context,
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
              ).copyWith(
    color: Colors.black87.withOpacity(0.6), // Applying low opacity
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
}
