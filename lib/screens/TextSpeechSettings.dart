import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gitgo/utils/tts_utils';

class TextSpeechSettings extends StatefulWidget {
  @override
  _TextSpeechSettingsState createState() => _TextSpeechSettingsState();
}

class _TextSpeechSettingsState extends State<TextSpeechSettings> {
  final FlutterTts flutterTts = FlutterTts();
  String? selectedLanguage;
  double pitch = 1.0;
  double speechRate = 1.0;

  final List<Map<String, String>> languageOptions = [
    {'value': 'en-US', 'label': 'English (US)'},
    {'value': 'en-UK', 'label': 'English (UK)'},
    {'value': 'de-DE', 'label': 'Deutsch'},
    {'value': 'da-DK', 'label': 'Dansk'},
    {'value': 'es-ES', 'label': 'Español'},
    {'value': 'nl-NL', 'label': 'Nederlands'},
    {'value': 'it-IT', 'label': 'Italiano'},
    {'value': 'zh-CN', 'label': '中文 (繁體)'},
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  Future<void> _loadCurrentSettings() async {
    selectedLanguage = await TtsUtils.getLanguage();
    pitch = await TtsUtils.getPitch();
    speechRate = await TtsUtils.getSpeechRate();
    setState(() {});
  }

  void _saveChanges() async {
    if (selectedLanguage != null) {
      await TtsUtils.setLanguage(selectedLanguage!);
      await TtsUtils.setPitch(pitch);
      await TtsUtils.setSpeechRate(speechRate);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _resetSettings() async {
    setState(() {
      selectedLanguage = TtsUtils.defaultLanguage;
      pitch = TtsUtils.defaultPitch;
      speechRate = TtsUtils.defaultSpeechRate;
    });
    await TtsUtils.setLanguage(selectedLanguage!);
    await TtsUtils.setPitch(pitch);
    await TtsUtils.setSpeechRate(speechRate);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings reset to default!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Text Speech Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          shadowColor: Colors.black12,
          child: Padding(
            padding: EdgeInsets.all(width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Text Speech Settings',
                    style: TextStyle(
                      fontSize: 18 * textScale,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Language',
                      labelStyle: TextStyle(
                        fontSize: 16 * textScale,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    value:
                        selectedLanguage!.isNotEmpty ? selectedLanguage : null,
                    onChanged: (value) {
                      setState(() {
                        selectedLanguage = value!;
                      });
                    },
                    items: languageOptions.map((language) {
                      return DropdownMenuItem<String>(
                        value: language['value'],
                        child: Text(language['label']!),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    'Pitch: ${pitch.toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 16 * textScale),
                  ),
                  Slider(
                    value: pitch,
                    onChanged: (value) {
                      setState(() {
                        pitch = value;
                      });
                    },
                    min: 0.5,
                    max: 2.0,
                    divisions: 15,
                    label: "Pitch: ${pitch.toStringAsFixed(1)}",
                    activeColor: Colors.blue,
                    inactiveColor: Colors.blue[100],
                    thumbColor: Colors.blue,
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    'Speech Rate: ${speechRate.toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 16 * textScale),
                  ),
                  Slider(
                    value: speechRate,
                    onChanged: (value) {
                      setState(() {
                        speechRate = value;
                      });
                    },
                    min: 0.1,
                    max: 2.0,
                    divisions: 19,
                    label: "Speech Rate: ${speechRate.toStringAsFixed(1)}",
                    activeColor: Colors.blue,
                    inactiveColor: Colors.blue[100],
                    thumbColor: Colors.blue,
                  ),
                  SizedBox(height: height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _resetSettings,
                        icon: const Icon(Icons.refresh, size: 20),
                        label: const Text(
                          'Reset',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.grey[600],
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.04,
                              vertical: height * 0.01),
                          elevation: 2,
                          shadowColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _saveChanges,
                        icon: const Icon(Icons.save, size: 20),
                        label: const Text(
                          'Save Changes',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.04,
                              vertical: height * 0.01),
                          elevation: 2,
                          shadowColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
