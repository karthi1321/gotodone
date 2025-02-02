import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gotodone/utils/shared_prefs_utils.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Map<String, String>> questionsAnswers = [];
  bool expandAll = true; // Default toggle state

  @override
  void initState() {
    super.initState();
    _loadFaqData();
    _loadExpandAllState();
  }

  Future<void> _loadFaqData() async {
    try {
      final String response =
          await rootBundle.loadString('assets/faq.json');
      final List<dynamic> data = json.decode(response);

      setState(() {
        questionsAnswers = data.map<Map<String, String>>((item) {
          return {
            'question': item['question'].toString(),
            'answer': item['answer'].toString(),
          };
        }).toList();
      });
    } catch (e) {
      print("Error loading JSON data: $e");
    }
  }

  Future<void> _loadExpandAllState() async {
    bool savedState = await SharedPrefsUtils.getExpandAllState();
    setState(() {
      expandAll = savedState;
    });
  }

  Future<void> _toggleExpandAll(bool value) async {
    setState(() {
      expandAll = value;
    });
    await SharedPrefsUtils.setExpandAllState(value); // Save the toggle state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Explore Git FAQs',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        // centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Toggle button with single label
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Expand All',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Transform.scale(
                  scale: 0.9, // Reduced toggle button size
                  child: Switch(
                    value: expandAll,
                    onChanged: _toggleExpandAll,
                    activeColor: Colors.blueAccent,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey[300],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline,
                      color: Colors.blue, size: 20),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Expand All'),
                        content: const Text(
                          'Toggle this switch to expand or collapse all the questions.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(), // Enables bouncing scroll

              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: questionsAnswers.length,
              itemBuilder: (context, index) {
                final item = questionsAnswers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: const Offset(0, 4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        focusColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: expandAll,
                        leading:
                            const Icon(Icons.help_outline, color: Colors.blue),
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            item['question']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    item['answer']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy,
                                      color: Colors.blue, size: 20),
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: item['answer']!));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Answer copied to clipboard"),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
