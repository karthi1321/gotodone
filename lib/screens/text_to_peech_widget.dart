import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gotodone/screens/TextSpeechSettings.dart';

import '../utils/tts_utils';

class TextToSpeechWidget extends StatefulWidget {
  const TextToSpeechWidget({Key? key}) : super(key: key);

  @override
  _TextToSpeechWidgetState createState() => _TextToSpeechWidgetState();
}

class _TextToSpeechWidgetState extends State<TextToSpeechWidget> {
  final TextEditingController _controller = TextEditingController();
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0), // Add margin to the container
      padding: const EdgeInsets.all(16.0), // Add padding to the container
      decoration: BoxDecoration(
        color: const Color.fromARGB(222, 255, 255, 255), // Set background color
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey), // Add border to the container
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Icon(Icons.info_outline,color: Colors.blue), // Info icon
                SizedBox(width: 8.0), // Add spacing between icon and text
                Text('Text to Speak'),

// Title text
              ]),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/textSpeechSettings');
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => TextSpeechSettings()),
                  // );
                },
                icon: Icon(Icons.settings),
              ), // Settings icon
            ],
          ),
          SizedBox(height: 8.0), // Add spacing between title and text area
          SizedBox(
            height: 200, // Set the fixed height here
            child: SingleChildScrollView(
              child: TextField(
                controller: _controller,
                minLines: 3,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Paste text here...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(8.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: 100, // Set a fixed width for the button
            child: ElevatedButton.icon(
              
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(
                        255, 25, 186, 255)), // Set button background color
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.all(12.0)),
              ),
              onPressed: () {
                if (!isPlaying) {
                  startSpeaking();
                } else {
                  stopSpeaking();
                }
              },
              icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow , color:  Colors.white,),
              label: Text(
                isPlaying ? 'Stop' : 'Speak',
                style: TextStyle(
                    color: Color.fromARGB(
                        255, 255, 255, 255)), // Set button text color
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> startSpeaking() async {
    setState(() {
      isPlaying = true;
    });
    await TtsUtils.speak(_controller.text);
    setState(() {
      isPlaying = false;
    });
  }

  void stopSpeaking() {
    setState(() {
      isPlaying = false;
    });
    TtsUtils.stop();
  }

  void downloadAudio() {
    // Implement the method to download the audio file
    // For example, you can use TtsUtils to generate the audio file and download it
    // You'll need to adjust this based on how you generate and download audio files in your app
    print('Downloading audio...');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}