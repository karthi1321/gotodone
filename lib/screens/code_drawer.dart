import 'package:flutter/services.dart';
import 'package:gotodone/constants/app_constants.dart';
import 'package:gotodone/screens/commands_list_page.dart';
import 'package:gotodone/screens/python_list_view.dart';
import 'package:flutter/material.dart';
import 'package:gotodone/screens/username_Input_page.dart';
import 'package:gotodone/utils/shared_prefs_utils.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:math' as math;

class CodeDrawer extends StatefulWidget {
  const CodeDrawer({super.key});

  @override
  _CodeDrawerState createState() => _CodeDrawerState();
}

class _CodeDrawerState extends State<CodeDrawer> {
  bool _showFeedbackDetails = false;
  String userName = 'gotodone';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    String name =
        await SharedPrefsUtils.getUsername(); // Call the utility function
    setState(() {
      userName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 18,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 6,
                                  child: Transform(
                                    transform: Matrix4.rotationY(math.pi),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'G',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ),
                                ),
                                const Positioned(
                                  right: 4,
                                  child: Text(
                                    'G',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'simple and smart',
                        style: TextStyle(
                          color: Color.fromARGB(232, 255, 255, 255),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            Icons.person, // Choose an appropriate icon
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(
                              width:
                                  8), // Add spacing between the icon and text
                          Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold, // Make the text bold
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                ListTile(
                  title: const Text('Roadmaps'),
                  leading: const Icon(Icons.computer, color: Colors.orange),
                  onTap: () {
                    Navigator.pushNamed(context, '/roadmapPage');
                  },
                ),

                ListTile(
                  title: const Text('Daily Tips'),
                  leading: const Icon(Icons.tips_and_updates,
                      color: Colors.blueAccent),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        duration: const Duration(milliseconds: 500),
                        child: PythonListView(),
                      ),
                    );
                  },
                ),

                ListTile(
                  title: const Text('Explore'),
                  leading: const Icon(Icons.explore, color: Colors.deepPurple),
                  onTap: () {
                    Navigator.pushNamed(context, '/explore'); // Fixed typo here
                  },
                ),
                ListTile(
                  title: const Text('Git Commands'),
                  leading: const Icon(Icons.merge_type, color: Colors.orange),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/sessionPage',
                      arguments: {'groupKey': RoadmapItems.all},
                    );
                  },
                ),

                // ExpansionTile(
                //   leading: const Icon(Icons.quiz, color: Colors.purple),
                //   title: const Text('Quiz Section'),
                //   children: <Widget>[
                //     ListTile(
                //       title: const Text('Quiz Option 1'),
                //       leading: const Icon(Icons.lightbulb_outline,
                //           color: Colors.amber),
                //       onTap: () {
                //         // Add Quiz Option 1 functionality
                //       },
                //     ),
                //     ListTile(
                //       title: const Text('Quiz Option 2'),
                //       leading:
                //           const Icon(Icons.question_answer, color: Colors.cyan),
                //       onTap: () {
                //         // Add Quiz Option 2 functionality
                //       },
                //     ),
                //   ],
                // ),

                ExpansionTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  children: <Widget>[
                    ListTile(
                      title: const Text('Edit Name'),
                      leading: Icon(Icons.person, color: Colors.blue),
                      onTap: () async {
                        final newName = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UsernameInputPage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Text Speech'),
                      leading:
                          Icon(Icons.record_voice_over, color: Colors.indigo),
                      onTap: () {
                        Navigator.pushNamed(context, '/textSpeechSettings');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.feedback, color: Colors.grey),
            title: const Text('Feedback'),
            onTap: () {
              setState(() {
                _showFeedbackDetails = !_showFeedbackDetails;
              });
            },
          ),
          if (_showFeedbackDetails)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Send any feedback to:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => _copyToClipboard(context),
                    child: const Text(
                      'karthick01.developer@gmail.com',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.info, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'About',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    const email = 'karthick01.developer@gmail.com';
    Clipboard.setData(const ClipboardData(text: email)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email address copied to clipboard')),
      );
    });
  }
}
