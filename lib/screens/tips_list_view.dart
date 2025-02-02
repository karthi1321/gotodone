import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/code_tip_model.dart';
import '../utils/tts_utils';
 
class TipsListView extends StatefulWidget {
  final List<CodeTipModel> tips;

  TipsListView({required this.tips});

  @override
  _TipsListViewState createState() => _TipsListViewState();
}

class _TipsListViewState extends State<TipsListView> {
  late List<bool> visitedTips;

  @override
  void initState() {
    super.initState();
    _loadVisitedTips();
  }

  Future<void> _loadVisitedTips() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedTips = prefs.getStringList('visited_tips');
    setState(() {
      visitedTips = storedTips != null
          ? storedTips.map((tip) => tip == 'true').toList()
          : List.filled(widget.tips.length, false);
    });
  }

  Future<void> _storeVisitedTip(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedTips =
        visitedTips.map((visited) => visited.toString()).toList();
    await prefs.setStringList('visited_tips', storedTips);
  }

  /// Method to format the tip by highlighting strings in quotes.
  Widget formatTipText(String tip) {
    final RegExp quotePattern = RegExp("r'([\'])(.*?)(\1)\'"); // Matches text in single or double quotes;
    final List<InlineSpan> spans = [];
    int lastMatchEnd = 0;

    // Find all matches for the quote pattern
    for (final match in quotePattern.allMatches(tip)) {
      // Add text before the match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: tip.substring(lastMatchEnd, match.start),
          style: const TextStyle(color: Colors.black),
        ));
      }

      // Add the highlighted text in quotes
      spans.add(TextSpan(
        text: match.group(0), // The entire match including quotes
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ));

      lastMatchEnd = match.end;
    }

    // Add remaining text after the last match
    if (lastMatchEnd < tip.length) {
      spans.add(TextSpan(
        text: tip.substring(lastMatchEnd),
        style: const TextStyle(color: Colors.black),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  Widget getTrailingWidget(int index) {
    if (visitedTips[index]) {
      return InkWell(
        onTap: () {
          TtsUtils.speak(widget.tips[index].tip);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[300],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.replay, color: Colors.black, size: 20),
              SizedBox(width: 6),
              Text(
                'Replay',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () async {
          TtsUtils.speak(widget.tips[index].tip);
          setState(() {
            visitedTips[index] = true;
          });
          await _storeVisitedTip(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.volume_up, color: Colors.white, size: 20),
              SizedBox(width: 6),
              Text(
                'Play',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: widget.tips.length,
      itemBuilder: (context, index) {
        final tip = widget.tips[index];
        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 239, 228, 129),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lightbulb,
                        color: Colors.orange,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Day ${tip.day}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                formatTipText(tip.tip),
                const SizedBox(height: 8),
                Text(
                  'Level: ${tip.level}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.bottomRight,
                  child: getTrailingWidget(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
